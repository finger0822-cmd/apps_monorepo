import 'dart:math' as math;
import 'package:flutter/material.dart';

// 調整可能パラメータ
const double g = 30.0; // 重力加速度（雪のようにゆっくり）
const double spawnRate = 400.0; // 1秒あたりの生成数（200.0から400.0に2倍に増加）
const int maxParticles = 5000; // 最大粒子数（900から5000に増加して途切れを防ぐ）

// ブラックホールパラメータ（超強力なブラックホール用）
const double basePull = 166666666.7; // ブラックホールの基本引力（16666666.67から166666666.7に10倍に増加）
const double softening = 1.0; // 近距離暴走防止（最小限に）
const double swirl = 0.5; // 渦成分の強さ
const double maxInfluenceDistance = 1000.0; // 最大影響距離（大幅に拡大）

// ホットリロードテスト用: この値を変更してrキーでホットリロードを試してください
// テスト: このコメントを変更して保存し、ターミナルで'r'キーを押してください

void main() {
  runApp(const SnowHoleApp());
}

class SnowHoleApp extends StatelessWidget {
  const SnowHoleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'snow_blackhole',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const SnowHoleDemo(),
    );
  }
}

class SnowHoleDemo extends StatefulWidget {
  const SnowHoleDemo({super.key});

  @override
  State<SnowHoleDemo> createState() => _SnowHoleDemoState();
}

class _SnowHoleDemoState extends State<SnowHoleDemo>
    with SingleTickerProviderStateMixin {
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();
  Offset? _blackHolePosition;
  late AnimationController _animationController;
  DateTime _lastUpdate = DateTime.now();
  double _accumulatedSpawn = 0.0;
  Size _screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _lastUpdate = DateTime.now();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(days: 1), // 長い期間を設定
    )..addListener(_onTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newSize = MediaQuery.of(context).size;
    if (newSize.width > 0 && newSize.height > 0) {
      _screenSize = newSize;
      // アニメーションが開始されていない場合のみ開始
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_animationController.isAnimating) {
          try {
            _animationController.repeat();
          } catch (e) {
            // エラーが発生した場合は無視
            debugPrint('Animation controller error: $e');
          }
        }
      });
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    // ホットリロード時にアニメーションを再開
    // ホットリロードを成功させるため、アニメーションコントローラーの処理を簡素化
    if (mounted && _screenSize.width > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_animationController.isAnimating) {
          try {
            _animationController.repeat();
          } catch (e) {
            // エラーが発生した場合は無視（ホットリロードを継続）
            debugPrint('Animation controller error during hot reload: $e');
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTick() {
    // mountedチェックを追加して、ホットリロード時のエラーを防ぐ
    if (!mounted) return;
    
    final now = DateTime.now();
    final dt = (now.difference(_lastUpdate).inMicroseconds / 1000000.0)
        .clamp(0.0, 0.1); // 最大0.1秒に制限
    if (dt <= 0) return;
    _lastUpdate = now;

    // setStateを安全に実行
    if (!mounted) return;
    setState(() {
      // 粒子生成（途切れを防ぐため、常に一定数以上の粒子を維持）
      _accumulatedSpawn += spawnRate * dt;
      // 一度に複数の粒子を生成できるように改善
      // 自然に降ってくるように、生成タイミングを少しずつずらす
      final particlesToSpawn = _accumulatedSpawn.floor();
      if (particlesToSpawn > 0) {
        for (int i = 0; i < particlesToSpawn && _particles.length < maxParticles; i++) {
          // 生成タイミングを少しずつずらすため、小さな遅延を追加
          final delay = i * 0.001; // 各粒子に1msずつ遅延
          _particles.add(_createParticle());
        }
        _accumulatedSpawn -= particlesToSpawn.toDouble();
      }
      
      // 粒子が少なすぎる場合は強制的に生成（途切れを防ぐ）
      final targetParticleCount = (spawnRate * 0.5).round(); // 0.5秒分の粒子を常に維持
      if (_particles.length < targetParticleCount && _particles.length < maxParticles) {
        final particlesNeeded = targetParticleCount - _particles.length;
        for (int i = 0; i < particlesNeeded && _particles.length < maxParticles; i++) {
          _particles.add(_createParticle());
        }
      }

      // 粒子更新
      final List<Particle> toRemove = [];
      for (final particle in _particles) {
        particle.update(dt, _blackHolePosition, _random);
        // 画面外に出た粒子を削除（全方位から生成するため、すべての方向をチェック）
        if (particle.y > _screenSize.height + 100 || 
            particle.y < -100 ||
            particle.x > _screenSize.width + 100 ||
            particle.x < -100 ||
            !particle.y.isFinite ||
            !particle.x.isFinite) {
          toRemove.add(particle);
        }
      }
      _particles.removeWhere((p) => toRemove.contains(p));
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (mounted) {
      setState(() {
        _blackHolePosition = details.localPosition;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (mounted) {
      setState(() {
        _blackHolePosition = details.localPosition;
      });
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (mounted) {
      setState(() {
        _blackHolePosition = null;
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (mounted) {
      setState(() {
        _blackHolePosition = details.localPosition;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (mounted) {
      setState(() {
        _blackHolePosition = null;
      });
    }
  }

  Particle _createParticle() {
    final width = _screenSize.width > 0 ? _screenSize.width : 400.0;
    final height = _screenSize.height > 0 ? _screenSize.height : 800.0;
    
    // 全方位から粒子を生成（画面の周囲から）
    final side = _random.nextInt(4); // 0: 上, 1: 右, 2: 下, 3: 左
    double x, y;
    double vx, vy;
    
    switch (side) {
      case 0: // 上
        x = _random.nextDouble() * width;
        y = -50.0 - _random.nextDouble() * 50.0;
        vx = (_random.nextDouble() - 0.5) * 30.0;
        vy = _random.nextDouble() * 20.0;
        break;
      case 1: // 右
        x = width + 50.0 + _random.nextDouble() * 50.0;
        y = _random.nextDouble() * height;
        vx = -(_random.nextDouble() * 20.0 + 10.0);
        vy = (_random.nextDouble() - 0.5) * 30.0;
        break;
      case 2: // 下
        x = _random.nextDouble() * width;
        y = height + 50.0 + _random.nextDouble() * 50.0;
        vx = (_random.nextDouble() - 0.5) * 30.0;
        vy = -(_random.nextDouble() * 20.0 + 10.0);
        break;
      case 3: // 左
        x = -50.0 - _random.nextDouble() * 50.0;
        y = _random.nextDouble() * height;
        vx = _random.nextDouble() * 20.0 + 10.0;
        vy = (_random.nextDouble() - 0.5) * 30.0;
        break;
      default:
        x = _random.nextDouble() * width;
        y = -50.0;
        vx = 0.0;
        vy = 0.0;
    }
    
    return Particle(
      x: x,
      y: y,
      vx: vx,
      vy: vy,
      size: (1.0 + _random.nextDouble() * 3.0) / 3.0 * 1.2, // サイズを1.2倍に
      alpha: 0.3 + _random.nextDouble() * 0.7,
    );
  }


  @override
  Widget build(BuildContext context) {
    final newSize = MediaQuery.of(context).size;
    if (newSize.width > 0 && newSize.height > 0) {
      _screenSize = newSize;
      // アニメーションが開始されていない場合のみ開始（buildメソッドでは一度だけ）
      if (!_animationController.isAnimating) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_animationController.isAnimating) {
            try {
              _animationController.repeat();
            } catch (e) {
              // エラーが発生した場合は無視
              debugPrint('Animation controller error in build: $e');
            }
          }
        });
      }
    }
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          painter: ParticlePainter(_particles, _blackHolePosition),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  final double size;
  final double alpha;
  final List<Offset> trail = []; // 軌跡を記録（吸い込まれる粒子用）
  static const int maxTrailLength = 20; // 軌跡の最大長さ
  bool isBeingPulled = false; // ブラックホールに引き寄せられているか

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.alpha,
  });

  void update(double dt, Offset? blackHole, math.Random random) {
    // 重力（雪のようにゆっくり）
    vy += g * dt;

    // 全方位に振れるように、ランダムな方向に動く
    final randomAngle = (random.nextDouble() - 0.5) * 2 * math.pi * 0.1; // 小さなランダムな角度変化
    final randomSpeed = (random.nextDouble() - 0.5) * 30.0; // ランダムな速度変化
    vx += math.cos(randomAngle) * randomSpeed * dt;
    vy += math.sin(randomAngle) * randomSpeed * dt;

    // ブラックホール効果（小さいブラックホール）
    if (blackHole == null) {
      // ブラックホールがない場合は軌跡をクリア
      isBeingPulled = false;
      trail.clear();
    } else {
      final dx = blackHole.dx - x;
      final dy = blackHole.dy - y;
      final distSq = dx * dx + dy * dy;
      final dist = math.sqrt(distSq);

      // 最大影響距離を超える場合は処理をスキップ
      if (dist > maxInfluenceDistance) {
        // 位置更新
        isBeingPulled = false;
        x += vx * dt;
        y += vy * dt;
        // 軌跡をクリア（影響範囲外では軌跡を残さない）
        trail.clear();
        return;
      }

      // ブラックホールの影響範囲内
      isBeingPulled = true;

      // 事象の地平線: 中心近くで消す
      if (dist < 20.0) {
        y = double.infinity; // 削除マーカー
        return;
      }

      // 超強力な引力（減衰を緩やかにして長距離でも影響）
      final distWithSoftening = dist + softening;
      // より長距離でも影響が残るように、減衰を非常に緩やかに
      final force = basePull / (distWithSoftening * distWithSoftening * 0.5);
      final fx = (dx / dist) * force;
      final fy = (dy / dist) * force;

      // 渦成分を追加（回転しながら吸い込まれる、影響を100分の1に）
      final swirlFx = -dy * swirl * force * 0.003; // 0.3から0.003に100分の1に減少
      final swirlFy = dx * swirl * force * 0.003; // 0.3から0.003に100分の1に減少

      vx += (fx + swirlFx) * dt;
      vy += (fy + swirlFy) * dt;

      // 速度上限（吸い込まれる様子が見えるように適度に制限、2倍に）
      final speed = math.sqrt(vx * vx + vy * vy);
      const maxSpeed = 400.0; // 200.0から400.0に2倍に増加
      if (speed > maxSpeed) {
        final scale = maxSpeed / speed;
        vx *= scale;
        vy *= scale;
      }
    }
    // 位置更新
    x += vx * dt;
    y += vy * dt;
    
    // ブラックホールに引き寄せられている場合のみ軌跡を記録
    if (isBeingPulled) {
      trail.add(Offset(x, y));
      if (trail.length > maxTrailLength) {
        trail.removeAt(0);
      }
    } else {
      // 影響範囲外では軌跡をクリア
      trail.clear();
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Offset? blackHolePosition;

  ParticlePainter(this.particles, this.blackHolePosition);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // 粒子描画
    for (final particle in particles) {
      if (particle.y.isFinite) {
        // ブラックホールに引き寄せられている粒子の軌跡を描画
        if (particle.isBeingPulled && particle.trail.length > 1) {
          for (int i = 0; i < particle.trail.length - 1; i++) {
            // 古い位置ほど薄く
            final trailAlpha = particle.alpha * (i + 1) / particle.trail.length * 0.5;
            paint.color = Colors.white.withOpacity(trailAlpha);
            paint.style = PaintingStyle.fill;
            final trailPos = particle.trail[i];
            // 軌跡のサイズも段階的に小さく
            final trailSize = particle.size * (0.2 + (i + 1) / particle.trail.length * 0.6);
            canvas.drawCircle(
              trailPos,
              trailSize,
              paint,
            );
          }
        }
        
        // 現在の粒子を描画
        paint.color = Colors.white.withOpacity(particle.alpha);
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size,
          paint,
        );
      }
    }

    // ブラックホール描画（強力なブラックホール、吸い込まれる様子を強調）
    if (blackHolePosition != null) {
      // 最大影響範囲の円（薄く表示）
      paint.color = Colors.white.withOpacity(0.12);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1.0;
      canvas.drawCircle(blackHolePosition!, maxInfluenceDistance, paint);
      
      // 中距離の円（より目立つように）
      paint.color = Colors.white.withOpacity(0.2);
      paint.strokeWidth = 1.5;
      canvas.drawCircle(blackHolePosition!, maxInfluenceDistance * 0.6, paint);
      
      // 内側の円（吸い込み範囲を強調）
      paint.color = Colors.white.withOpacity(0.4);
      paint.strokeWidth = 2.0;
      canvas.drawCircle(blackHolePosition!, 60.0, paint);
      
      // 事象の地平線（吸い込まれる範囲）
      paint.color = Colors.white.withOpacity(0.6);
      paint.strokeWidth = 2.5;
      canvas.drawCircle(blackHolePosition!, 25.0, paint);
      
      // 中心点（ブラックホールの中心）
      paint.color = Colors.white.withOpacity(0.9);
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(blackHolePosition!, 4.0, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return true;
  }
}
