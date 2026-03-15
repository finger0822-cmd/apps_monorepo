import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // アイコン全体のスケールアニメ
  late AnimationController _iconController;
  late Animation<double> _iconScale;
  late Animation<double> _iconOpacity;

  // バーごとのアニメ（5本）
  late List<AnimationController> _barControllers;
  late List<Animation<double>> _barHeights;

  // テキストのフェードアニメ
  late AnimationController _textController;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  // ドットのフェードアニメ
  late AnimationController _dotsController;
  late Animation<double> _dotsOpacity;

  static const Color _purple = Color(0xFF7B5EA7);
  static const Color _barColor = Color(0xFF7B5EA7);

  // バーの最終的な高さ（dp）
  final List<double> _targetHeights = [38, 50, 60, 52, 44];

  @override
  void initState() {
    super.initState();

    // --- アイコン ---
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _iconScale = CurvedAnimation(
      parent: _iconController,
      curve: const ElasticOutCurve(0.8),
    );
    _iconOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0, 0.4, curve: Curves.easeIn),
      ),
    );

    // --- バー（ストリームアニメ） ---
    _barControllers = List.generate(
      5,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );
    _barHeights = List.generate(
      5,
      (i) => Tween<double>(begin: 0, end: _targetHeights[i]).animate(
        CurvedAnimation(
          parent: _barControllers[i],
          curve: const ElasticOutCurve(0.9),
        ),
      ),
    );

    // --- テキスト ---
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // --- ドット ---
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _dotsOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _dotsController, curve: Curves.easeOut),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    // 200ms後にアイコン表示
    await Future.delayed(const Duration(milliseconds: 200));
    _iconController.forward();

    // バーを順番に立ち上げる
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      _barControllers[i].forward();
    }

    // テキスト表示
    await Future.delayed(const Duration(milliseconds: 100));
    _textController.forward();

    // ドット表示
    await Future.delayed(const Duration(milliseconds: 200));
    _dotsController.forward();

    // 次の画面へ遷移
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget.nextScreen,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    for (final c in _barControllers) {
      c.dispose();
    }
    _textController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _purple,
      body: Stack(
        children: [
          // 背景の装飾円
          _buildBgCircle(
            top: -100,
            left: -100,
            size: 400,
            delay: 0,
          ),
          _buildBgCircle(
            bottom: -60,
            right: -60,
            size: 300,
            delay: 800,
          ),
          _buildBgCircle(
            topFraction: 0.4,
            leftFraction: 0.1,
            size: 180,
            delay: 400,
          ),

          // メインコンテンツ
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // アイコン
                ScaleTransition(
                  scale: _iconScale,
                  child: FadeTransition(
                    opacity: _iconOpacity,
                    child: _buildIcon(),
                  ),
                ),

                const SizedBox(height: 28),

                // アプリ名
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: const Text(
                      'MindCapsule',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // キャッチコピー
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: const Text(
                      'Capture your mood. Understand yourself.',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // ページドット
                FadeTransition(
                  opacity: _dotsOpacity,
                  child: _buildDots(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // 中央の縦線
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 1,
                  color: const Color(0xFF9B80C7),
                ),
              ),
            ),
            // バー群
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(5, (i) {
                return Padding(
                  padding: EdgeInsets.only(right: i < 4 ? 5 : 0),
                  child: AnimatedBuilder(
                    animation: _barHeights[i],
                    builder: (_, __) {
                      return Container(
                        width: 16,
                        height: _barHeights[i].value,
                        decoration: BoxDecoration(
                          color: _barColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3),
                            topRight: Radius.circular(3),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // アクティブドット（長め）
        Container(
          width: 20,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        // 非アクティブドット × 2
        ...List.generate(2, (_) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ],
    );
  }

  /// 背景の装飾円（パルスアニメ付き）
  Widget _buildBgCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? topFraction,
    double? leftFraction,
    required double size,
    required int delay,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      double? resolvedTop = top;
      double? resolvedLeft = left;

      if (topFraction != null) {
        resolvedTop = MediaQuery.of(context).size.height * topFraction;
      }
      if (leftFraction != null) {
        resolvedLeft = MediaQuery.of(context).size.width * leftFraction;
      }

      return Positioned(
        top: resolvedTop,
        bottom: bottom,
        left: resolvedLeft,
        right: right,
        child: _PulseCircle(size: size, delay: Duration(milliseconds: delay)),
      );
    });
  }
}

/// パルスするサークルウィジェット
class _PulseCircle extends StatefulWidget {
  final double size;
  final Duration delay;

  const _PulseCircle({required this.size, required this.delay});

  @override
  State<_PulseCircle> createState() => _PulseCircleState();
}

class _PulseCircleState extends State<_PulseCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 0.6), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.6, end: 0.3), weight: 50),
    ]).animate(_controller);
    _scale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0), weight: 50),
    ]).animate(_controller);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
