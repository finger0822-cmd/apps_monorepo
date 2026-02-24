import 'package:core_state/core_state.dart';
import 'package:flutter/material.dart';

/// Displays 3 mini line charts (energy, focus, fatigue) from [entries].
/// No labels, no evaluation - flow only. Uses same colors as NextScreen.
class MiniWaveBlock extends StatelessWidget {
  const MiniWaveBlock({super.key, this.entries, this.chartHeight = 48.0});

  final List<DailyStateEntry>? entries;
  final double chartHeight;

  static const _chartSpacing = 16.0;
  static const _energyColor = Color(0xFFC2C2C2);
  static const _focusColor = Color(0xFF9A9A9A);
  static const _fatigueColor = Color(0xFF7A7A7A);

  @override
  Widget build(BuildContext context) {
    if (entries == null || entries!.isEmpty) {
      return const SizedBox.shrink();
    }

    final energyValues =
        entries!.map((e) => e.energy.value.toDouble()).toList();
    final focusValues = entries!.map((e) => e.focus.value.toDouble()).toList();
    final fatigueValues =
        entries!.map((e) => e.fatigue.value.toDouble()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _MiniLineChart(values: energyValues, lineColor: _energyColor, height: chartHeight),
        const SizedBox(height: _chartSpacing),
        _MiniLineChart(values: focusValues, lineColor: _focusColor, height: chartHeight),
        const SizedBox(height: _chartSpacing),
        _MiniLineChart(values: fatigueValues, lineColor: _fatigueColor, height: chartHeight),
      ],
    );
  }
}

class _MiniLineChart extends StatelessWidget {
  const _MiniLineChart({
    required this.values,
    required this.lineColor,
    this.height = 48.0,
  });

  final List<double> values;
  final Color lineColor;
  final double height;

  static const _rangeColor = Color(0xFF555555);

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          width: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '5',
                style: TextStyle(
                  color: _rangeColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '1',
                style: TextStyle(
                  color: _rangeColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: height,
            child: CustomPaint(
              painter: _LineChartPainter(
                values: values,
                lineColor: lineColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({required this.values, required this.lineColor});

  final List<double> values;
  final Color lineColor;

  static const _min = 1.0;
  static const _max = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final stepX = (values.length > 1) ? w / (values.length - 1) : 0.0;

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = h - (values[i] - _min) / (_max - _min) * h;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.lineColor != lineColor;
  }
}
