import 'package:core_state/core_state.dart';
import 'package:flutter/material.dart';

import '../../domain/insights/rhythm_detector.dart';
import 'sparkline_wave.dart';

/// Today画面ヘッダー用。折れ線1本＋ラベル1行。背景情報として控えめに。
/// [useFixedHeightLayout] true のとき Next/Insight 用：Stack で折れ線上寄せ・ラベル右下固定。
class WaveHeader extends StatelessWidget {
  const WaveHeader({
    super.key,
    this.entries,
    this.rhythmResult,
    this.useFixedHeightLayout = false,
  });

  final List<DailyStateEntry>? entries;
  final ProvisionalRhythmResult? rhythmResult;
  final bool useFixedHeightLayout;

  static const _labelColor = Color(0xFFB0B0B0);
  static const _lineColor = Color(0xFFC2C2C2);
  static const _waveHeight = 56.0;
  static const _horizontalPadding = 16.0;
  static const _topPadding = 6.0;
  static const _widthFactor = 0.7;
  static const _labelRight = 16.0;
  static const _labelBottom = 8.0;

  @override
  Widget build(BuildContext context) {
    if (entries == null || entries!.isEmpty) {
      if (useFixedHeightLayout) {
        return const SizedBox.shrink();
      }
      return const Padding(
        padding: EdgeInsets.only(
          left: _horizontalPadding,
          right: _horizontalPadding,
          top: _topPadding,
        ),
        child: SizedBox(height: _waveHeight + 20),
      );
    }
    final sorted = entries!.toList()..sort((a, b) => a.date.compareTo(b.date));
    final last7 = sorted.length > 7 ? sorted.sublist(sorted.length - 7) : sorted;
    final rawScores = last7.map((e) => waveScoreFor(e)).toList();
    final normalized = normalizeWaveScoresToUnit(rawScores);
    final label = rhythmResult != null
        ? rhythmResult!.rhythmLabel
        : '波：ゆるやか';
    final width = MediaQuery.sizeOf(context).width * _widthFactor;

    final waveChild = Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: width,
        child: SparklineWave(
          values: normalized,
          height: _waveHeight,
          lineColor: _lineColor,
          strokeWidth: 0.8,
          opacity: 0.4,
        ),
      ),
    );

    final labelWidget = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 12,
        color: _labelColor.withOpacity(0.6),
        fontWeight: FontWeight.w400,
      ),
    );

    if (useFixedHeightLayout) {
      return Stack(
        children: [
          waveChild,
          Positioned(
            right: _labelRight,
            bottom: _labelBottom,
            child: labelWidget,
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: _horizontalPadding,
        right: _horizontalPadding,
        top: _topPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          waveChild,
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: labelWidget,
          ),
        ],
      ),
    );
  }
}
