import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const ParticleApp());
}

class ParticleApp extends StatelessWidget {
  const ParticleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ParticleHome(),
    );
  }
}

class ParticleHome extends StatefulWidget {
  const ParticleHome({super.key});

  @override
  State<ParticleHome> createState() => _ParticleHomeState();
}

class _ParticleHomeState extends State<ParticleHome>
    with SingleTickerProviderStateMixin {
  late final ParticleSystem _system;
  late final Ticker _ticker;
  Duration? _lastTick;

  @override
  void initState() {
    super.initState();
    _system = ParticleSystem(
      config: const ParticleConfig(),
      emitter: const TapBurstEmitter(),
    );
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (_lastTick == null) {
      _lastTick = elapsed;
      return;
    }
    final dt = (elapsed - _lastTick!).inMicroseconds / 1e6;
    _lastTick = elapsed;
    if (dt <= 0) {
      return;
    }
    setState(() {
      _system.tick(dt);
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final local = box.globalToLocal(details.globalPosition);
    setState(() {
      _system.spawn(local);
    });
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTap,
        child: CustomPaint(
          painter: ParticlePainter(_system.particles),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class Particle {
  const Particle({
    required this.position,
    required this.velocity,
    required this.life,
    required this.size,
  });

  final Offset position;
  final Offset velocity;
  final double life;
  final double size;

  Particle copyWith({
    Offset? position,
    Offset? velocity,
    double? life,
    double? size,
  }) {
    return Particle(
      position: position ?? this.position,
      velocity: velocity ?? this.velocity,
      life: life ?? this.life,
      size: size ?? this.size,
    );
  }
}

class ParticleConfig {
  const ParticleConfig({
    this.particlesPerBurst = 800,
    this.friction = 0.92,
    this.lifeDecay = 0.6,
    this.minSpeed = 120,
    this.maxSpeed = 900,
    this.minSize = 0.6,
    this.maxSize = 1.8,
    this.maxParticles = 12000,
    this.centerFillParticles = 120,
    this.centerFillSpeedMax = 140,
  });

  final int particlesPerBurst;
  final double friction;
  final double lifeDecay;
  final double minSpeed;
  final double maxSpeed;
  final double minSize;
  final double maxSize;
  final int maxParticles;
  final int centerFillParticles;
  final double centerFillSpeedMax;
}

abstract class ParticleEmitter {
  const ParticleEmitter();

  List<Particle> emit(
    Offset position,
    ParticleConfig config,
    math.Random rng,
  );
}

class TapBurstEmitter extends ParticleEmitter {
  const TapBurstEmitter();

  @override
  List<Particle> emit(
    Offset position,
    ParticleConfig config,
    math.Random rng,
  ) {
    final particles = <Particle>[];
    for (var i = 0; i < config.particlesPerBurst; i++) {
      final angle = rng.nextDouble() * math.pi * 2;
      final speed = _lerp(
        config.minSpeed,
        config.maxSpeed,
        rng.nextDouble(),
      );
      final velocity = Offset(math.cos(angle), math.sin(angle)) * speed;
      final size = _lerp(config.minSize, config.maxSize, rng.nextDouble());
      particles.add(
        Particle(
          position: position,
          velocity: velocity,
          life: 1.0,
          size: size,
        ),
      );
    }
    for (var i = 0; i < config.centerFillParticles; i++) {
      final angle = rng.nextDouble() * math.pi * 2;
      final speed = _lerp(0, config.centerFillSpeedMax, rng.nextDouble());
      final velocity = Offset(math.cos(angle), math.sin(angle)) * speed;
      final size = _lerp(config.minSize, config.maxSize, rng.nextDouble());
      particles.add(
        Particle(
          position: position,
          velocity: velocity,
          life: 1.0,
          size: size,
        ),
      );
    }
    return particles;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

class ParticleSystem {
  ParticleSystem({
    required this.config,
    required this.emitter,
  }) : _rng = math.Random();

  final ParticleConfig config;
  final ParticleEmitter emitter;
  final math.Random _rng;
  final List<Particle> particles = [];

  void spawn(Offset position) {
    final newParticles = emitter.emit(position, config, _rng);
    particles.addAll(newParticles);
    final overflow = particles.length - config.maxParticles;
    if (overflow > 0) {
      particles.removeRange(0, overflow);
    }
  }

  void tick(double dt) {
    if (particles.isEmpty) {
      return;
    }
    final frictionFactor =
        math.pow(config.friction, dt * 60).toDouble();
    for (var i = 0; i < particles.length; i++) {
      final particle = particles[i];
      final position = particle.position + particle.velocity * dt;
      final velocity = particle.velocity * frictionFactor;
      final life = particle.life - config.lifeDecay * dt;
      particles[i] = particle.copyWith(
        position: position,
        velocity: velocity,
        life: life,
      );
    }
    particles.removeWhere((particle) => particle.life <= 0);
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(this.particles);

  final List<Particle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, background);

    final paint = Paint()..style = PaintingStyle.fill;
    for (final particle in particles) {
      final alpha = (particle.life.clamp(0.0, 1.0) * 255).toInt();
      paint.color = Colors.white.withAlpha(alpha);
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return true;
  }
}
