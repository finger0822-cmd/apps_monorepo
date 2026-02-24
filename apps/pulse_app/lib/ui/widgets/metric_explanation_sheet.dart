import 'package:flutter/material.dart';

import '../../domain/metrics/pulse_metric.dart';

/// 項目名の長押しで表示する説明シート。Pulseの静かなトーンで表示する。
class MetricExplanationSheet extends StatelessWidget {
  const MetricExplanationSheet({super.key, required this.metric});

  final PulseMetric metric;

  static const _bg = Color(0xFF1A1A1A);
  static const _textColor = Color(0xFFC2C2C2);
  static const _mutedColor = Color(0xFF777777);

  /// シートを表示する。項目名の長押しから呼ぶ。
  static Future<void> show(BuildContext context, PulseMetric metric) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: _bg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => SafeArea(
        child: MetricExplanationSheet(metric: metric),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            metric.descriptionTitle,
            style: const TextStyle(
              fontSize: 18,
              color: _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            metric.descriptionBody,
            style: const TextStyle(
              fontSize: 14,
              color: _textColor,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          _GuideRow(label: '1に近いとき', text: metric.lowGuide),
          const SizedBox(height: 10),
          _GuideRow(label: '5に近いとき', text: metric.highGuide),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: const Text(
              '閉じる',
              style: TextStyle(
                fontSize: 14,
                color: _mutedColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  const _GuideRow({required this.label, required this.text});

  final String label;
  final String text;

  static const _mutedColor = Color(0xFF777777);
  static const _textColor = Color(0xFFC2C2C2);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: _mutedColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: _textColor,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
