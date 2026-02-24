import 'package:core_state/core_state.dart';
import 'package:flutter/material.dart';

/// 1日分の合成スコア。fatigue は高いほど悪いので 6 - fatigue で反転。
double waveScoreFor(DailyStateEntry e) {
  return (e.energy.value + e.focus.value + (6 - e.fatigue.value)) / 3.0;
}

/// 低変動時も波の視認性を保つための最小表示レンジ（スコア単位。waveScore はおおよそ 1〜5）。
const double kMinVisualRange = 0.4;

/// 直近の waveScore を 0..1 に正規化（min-max）。
/// 低変動時は表示レンジに最小幅を持たせ、平坦に見えすぎないようにする（データ値は変更しない）。
List<double> normalizeWaveScoresToUnit(List<double> raw) {
  if (raw.isEmpty) return [];
  if (raw.length == 1) return [0.5];
  final dataMin = raw.reduce((a, b) => a < b ? a : b);
  final dataMax = raw.reduce((a, b) => a > b ? a : b);
  final dataSpan = dataMax - dataMin;
  if (dataSpan <= 0) return List.filled(raw.length, 0.5);

  final center = (dataMin + dataMax) / 2;
  final displaySpan = dataSpan < kMinVisualRange ? kMinVisualRange : dataSpan;
  final displayMin = center - displaySpan / 2;
  final displayMax = center + displaySpan / 2;

  return raw.map((v) => ((v - displayMin) / displaySpan).clamp(0.0, 1.0)).toList();
}

/// グラフ内部の描画余白（px）。縦長端末でも呼吸感を保つ。
const double kWaveGraphPadTop = 12.0;   // 6→12（+6px）で「この1週間」と折れ線の距離を自然に
const double kWaveGraphPadBottom = 24.0;  // 記録見出しとの視覚干渉解消のため維持
const double kWaveYRangeMarginFactor = 0.15;  // Yレンジ上下マージン（維持）

/// 薄い1本折れ線。軸・目盛・数値なし。Pulseの静けさを維持。
/// 描画領域の bottom padding を十分取り、Yレンジに上下マージンを入れて線が端に張り付かないようにする。
class SparklineWavePainter extends CustomPainter {
  SparklineWavePainter({
    required List<double> values,
    this.lineColor = const Color(0xFF555555),
    this.strokeWidth = 1.2,
    this.opacity = 0.55,
  }) : values = List.from(values);

  final List<double> values;
  final Color lineColor;
  final double strokeWidth;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final w = size.width;
    final h = size.height;
    final padX = w * 0.08;
    final drawW = w - 2 * padX;
    final padYTop = kWaveGraphPadTop;
    final padYBottom = kWaveGraphPadBottom;
    final drawH = h - padYTop - padYBottom;
    if (drawW <= 0 || drawH <= 0) return;

    final marginY = (drawH * kWaveYRangeMarginFactor).clamp(2.0, 6.0);
    final rangeH = drawH - 2 * marginY;

    final path = Path();
    final stepX = (values.length > 1) ? drawW / (values.length - 1) : 0.0;

    for (int i = 0; i < values.length; i++) {
      final x = padX + i * stepX;
      final y = padYTop + marginY + (1.0 - values[i]) * rangeH;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = lineColor.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SparklineWavePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.opacity != opacity;
  }
}

/// 薄いスパークライン1本。高さ60〜90px、幅は親に合わせる。
class SparklineWave extends StatelessWidget {
  const SparklineWave({
    super.key,
    required this.values,
    this.height = 72.0,
    this.lineColor = const Color(0xFF555555),
    this.strokeWidth = 1.2,
    this.opacity = 0.55,
  });

  final List<double> values;
  final double height;
  final Color lineColor;
  final double strokeWidth;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) return SizedBox(height: height);
    final padYTop = kWaveGraphPadTop;
    final padYBottom = kWaveGraphPadBottom;
    final drawH = height - padYTop - padYBottom;
    final marginY = (drawH * kWaveYRangeMarginFactor).clamp(2.0, 6.0);
    final rangeH = drawH - 2 * marginY;
    final rawMinY = values.reduce((a, b) => a < b ? a : b);
    final rawMaxY = values.reduce((a, b) => a > b ? a : b);
    final displayMinY = padYTop + marginY;
    final displayMaxY = padYTop + marginY + rangeH;
    debugPrint('[Pulse Wave] graph widget height=$height, '
        'internal top padding=$padYTop, internal bottom padding=$padYBottom, '
        'drawH=$drawH, marginY=$marginY, rangeH=$rangeH, '
        'raw minY=$rawMinY, raw maxY=$rawMaxY, '
        'display line topY=$displayMinY, bottomY=$displayMaxY (px from top)');
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: SparklineWavePainter(
          values: values,
          lineColor: lineColor,
          strokeWidth: strokeWidth,
          opacity: opacity,
        ),
      ),
    );
  }
}
