import 'package:core_state/core_state.dart';
import 'package:flutter/material.dart';

import '../core/aha_prefs.dart';
import '../core/pulse_dependencies.dart';
import '../domain/insights/header_insight_builder.dart';
import '../domain/insights/rhythm_detector.dart';
import '../domain/metrics/pulse_metric.dart';
import '../l10n/app_localizations.dart';
import 'widgets/home_overflow_menu.dart';
import 'widgets/sparkline_wave.dart';
import 'ai_tendency_screen.dart';

/// 2枚目：7〜30日のグラフ観測（観測専用）。5項目を縦並びで表示。入力UIは出さず観測のみ。
// ----- 余白スケール（用途別に参照し、二重取り・過剰を防ぐ）
const double spacingXs = 4.0;
const double spacingSm = 8.0;
const double spacingMd = 12.0;
const double spacingLg = 16.0;

// ----- 観測ブロック内
const double observationInternalSpacing = 6.0;
const double observationPeriodLabelToWave = 10.0;
const double observationChartRowHeight = 40.0;  // 1項目あたりのグラフ高さ
const double observationChartRowGap = 10.0;     // 項目間の余白

// ----- 観測ブロック下 ↔ 「傾向分析を見る」導線の余白（2枚目は観測専用のため入力UIなし）
const double observationToLinkGap = 32.0;
const double linkBottomPadding = 32.0;

// ----- スクロール領域（Padding は上下のみ）
const double scrollTopPadding = 6.0;
const double scrollBottomPadding = 24.0;

/// 期間ラベル文言（例: この1週間（2/17–2/23））。
String _formatPeriodLabel(List<DailyStateEntry> entries, int periodDays) {
  if (entries.isEmpty) return 'データがありません';
  final sorted = entries.toList()..sort((a, b) => a.date.compareTo(b.date));
  final first = sorted.first.date;
  final last = sorted.last.date;
  final from = '${first.month}/${first.day}';
  final to = '${last.month}/${last.day}';
  if (periodDays <= 7) return 'この1週間（$from–$to）';
  if (periodDays <= 14) return 'この2週間（$from–$to）';
  return 'この30日（$from–$to）';
}

/// 観測ブロック。解釈・補助・期間切替・期間ラベル・グラフを重ねず縦積み（Column のみ）。
class WaveObservationBlock extends StatelessWidget {
  const WaveObservationBlock({
    super.key,
    required this.entries,
    this.rhythmResult,
    required this.periodDays,
    required this.onPeriodChanged,
  });

  final List<DailyStateEntry> entries;
  final ProvisionalRhythmResult? rhythmResult;
  final int periodDays;
  final ValueChanged<int> onPeriodChanged;

  static const _labelColor = Color(0xFFC2C2C2);
  static const _mutedColor = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    final sorted = entries.isEmpty ? <DailyStateEntry>[] : entries.toList()..sort((a, b) => a.date.compareTo(b.date));
    final rawScores = sorted.map((e) => waveScoreFor(e)).toList();
    final insight = entries.isEmpty ? null : buildHeaderInsight(rawScores);
    final showInsight = insight != null && insight.message.isNotEmpty;
    final rhythmLabel = rhythmResult != null
        ? '今日のリズム：${rhythmResult!.estimatedCycleDays}日'
        : '今日のリズム：ゆるやか';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. 解釈文（最大2行・overflow対策）
        if (showInsight)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              insight!.message,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: _labelColor.withOpacity(0.95),
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
          ),
        if (showInsight) const SizedBox(height: observationInternalSpacing),
        // 2. 補助文（1行）
        Text(
          rhythmLabel,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: _labelColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: observationInternalSpacing),
        // 3. 期間切替
        _PeriodChips(
          periodDays: periodDays,
          onChanged: onPeriodChanged,
        ),
        const SizedBox(height: observationInternalSpacing),
        // 4. 期間ラベル
        Text(
          _formatPeriodLabel(entries, periodDays),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            color: _mutedColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: observationPeriodLabelToWave),
        // 5. 5項目のグラフ（縦並び・small multiples）。最小高さで描画崩れを防止。
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 5 * observationChartRowHeight + 4 * observationChartRowGap,
          ),
          child: entries.isNotEmpty
              ? _ObservationChartsBlock(entries: entries)
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'データがありません',
                      style: TextStyle(fontSize: 13, color: Color(0xFF777777), fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class NextScreen extends StatefulWidget {
  const NextScreen({
    super.key,
    required this.deps,
    required this.energy,
    required this.focus,
    required this.fatigue,
    required this.date,
  });

  final PulseDependencies deps;
  final int energy;
  final int focus;
  final int fatigue;
  final DateTime date;

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  List<DailyStateEntry>? _entries;
  int _periodDays = 7;
  bool _showingAha = false;
  ProvisionalRhythmResult? _ahaRhythmResult;
  ProvisionalRhythmResult? _rhythmResult;

  /// 表示用の直近 _periodDays 件（日付昇順）。
  List<DailyStateEntry> get _entriesForPeriod {
    if (_entries == null || _entries!.isEmpty) return [];
    final sorted = _entries!.toList()..sort((a, b) => a.date.compareTo(b.date));
    final n = sorted.length;
    if (n <= _periodDays) return sorted;
    return sorted.sublist(n - _periodDays, n);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await widget.deps.repo.latest(30);
    if (!mounted) return;
    final sorted = list..sort((a, b) => a.date.compareTo(b.date));
    final rhythm = sorted.length >= 7 ? detectProvisionalRhythm(sorted) : null;
    setState(() {
      _entries = sorted;
      _rhythmResult = rhythm;
    });
    if (sorted.length >= 7) {
      final hasSeen = await AhaPrefs.hasSeenAhaMoment();
      if (!mounted) return;
      if (!hasSeen && rhythm != null) {
        setState(() {
          _showingAha = true;
          _ahaRhythmResult = rhythm;
        });
      }
    }
  }

  Future<void> _onAhaContinue() async {
    await AhaPrefs.setHasSeenAhaMoment(true);
    if (mounted) setState(() => _showingAha = false);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F0F0F);
    final l10n = AppLocalizations.of(context);

    if (_showingAha && _ahaRhythmResult != null && _entries != null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const SizedBox.shrink(),
          actions: [
            HomeOverflowButton(
              deps: widget.deps,
              onSettingsPopped: () {
                if (mounted) _load();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: _AhaMomentContent(
            title: l10n.ahaTitle,
            rhythmResult: _ahaRhythmResult!,
            entries: _entries!,
            continueLabel: l10n.continueLabel,
            onContinue: () => _onAhaContinue(),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const SizedBox.shrink(),
        actions: [
            HomeOverflowButton(
              deps: widget.deps,
              onSettingsPopped: () {
                if (mounted) _load();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: scrollTopPadding,
                  bottom: linkBottomPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WaveObservationBlock(
                      entries: _entriesForPeriod,
                      rhythmResult: _entriesForPeriod.length >= 7
                          ? detectProvisionalRhythm(_entriesForPeriod)
                          : _rhythmResult,
                      periodDays: _periodDays,
                      onPeriodChanged: (v) => setState(() => _periodDays = v),
                    ),
                    const SizedBox(height: observationToLinkGap),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => AiTendencyScreen(deps: widget.deps),
                            ),
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            l10n.viewTendencyAnalysisLink,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF777777),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 7日 / 14日 / 30日 の静かな切替。選択はサイズ・ウェイトで差を出す。
class _PeriodChips extends StatelessWidget {
  const _PeriodChips({
    required this.periodDays,
    required this.onChanged,
  });

  final int periodDays;
  final ValueChanged<int> onChanged;

  static const _mutedColor = Color(0xFF777777);
  static const _labelColor = Color(0xFFC2C2C2);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _chip(7, '7日'),
        const SizedBox(width: 16),
        _chip(14, '14日'),
        const SizedBox(width: 16),
        _chip(30, '30日'),
      ],
    );
  }

  Widget _chip(int value, String label) {
    final selected = periodDays == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Text(
          label,
          style: TextStyle(
            fontSize: selected ? 14 : 13,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            color: selected ? _labelColor : _mutedColor,
          ),
        ),
      ),
    );
  }
}

class _RhythmBlock extends StatelessWidget {
  const _RhythmBlock({this.entries, this.rhythmResult});

  final List<DailyStateEntry>? entries;
  final ProvisionalRhythmResult? rhythmResult;

  static const _labelColor = Color(0xFFC2C2C2);
  static const _energyColor = Color(0xFFC2C2C2);

  @override
  Widget build(BuildContext context) {
    if (entries == null || entries!.isEmpty) return const SizedBox.shrink();
    final sorted = entries!.toList()..sort((a, b) => a.date.compareTo(b.date));
    final last7 = sorted.length > 7 ? sorted.sublist(sorted.length - 7) : sorted;
    final rawScores = last7.map((e) => waveScoreFor(e)).toList();
    final normalized = normalizeWaveScoresToUnit(rawScores);
    final label = rhythmResult != null
        ? rhythmResult!.rhythmLabel
        : '波：ゆるやか';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: SparklineWave(
              values: normalized,
              height: 72,
              lineColor: _energyColor,
              strokeWidth: 1.2,
              opacity: 0.55,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: _labelColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _AhaMomentContent extends StatelessWidget {
  const _AhaMomentContent({
    required this.title,
    required this.rhythmResult,
    required this.entries,
    required this.continueLabel,
    required this.onContinue,
  });

  final String title;
  final ProvisionalRhythmResult rhythmResult;
  final List<DailyStateEntry> entries;
  final String continueLabel;
  final VoidCallback onContinue;

  static const _durationChart = Duration(milliseconds: 800);
  static const _durationText = Duration(milliseconds: 500);
  static const _textColor = Color(0xFFC2C2C2);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 1),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: _durationText,
            curve: Curves.easeOut,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: child,
            ),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: _textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: _durationChart,
            curve: Curves.easeOut,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: child,
            ),
            child: _RhythmBlock(
              entries: entries,
              rhythmResult: rhythmResult,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: GestureDetector(
              onTap: onContinue,
              behavior: HitTestBehavior.opaque,
              child: Text(
                continueLabel,
                style: const TextStyle(
                  fontSize: 16,
                  color: _textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _ObservationChartsBlock extends StatelessWidget {
  const _ObservationChartsBlock({required this.entries});

  final List<DailyStateEntry> entries;

  static const _labelColor = Color(0xFFC2C2C2);
  static const _mutedColor = Color(0xFF777777);
  static const _chartColors = [
    Color(0xFFC2C2C2),
    Color(0xFF9A9A9A),
    Color(0xFF7A7A7A),
    Color(0xFF6A6A6A),
    Color(0xFF5A5A5A),
  ];

  List<double> _valuesFor(List<DailyStateEntry> sorted, String metricId) {
    switch (metricId) {
      case 'energy':
        return sorted.map((e) => e.energy.value.toDouble()).toList();
      case 'focus':
        return sorted.map((e) => e.focus.value.toDouble()).toList();
      case 'fatigue':
        return sorted.map((e) => e.fatigue.value.toDouble()).toList();
      case 'mood':
      case 'sleepiness':
        return [];
      default:
        return [];
    }
  }

  static const _rowExtent = 52.0; // 1行あたり（5行を一覧で見せる）
  static const _blockHeight = 320.0; // ラベル＋5行＋余白で固定

  @override
  Widget build(BuildContext context) {
    final sorted = entries.toList()..sort((a, b) => a.date.compareTo(b.date));
    final dates = sorted.map((e) => e.date).toList();

    return SizedBox(
      height: _blockHeight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              '気力・集中・疲れ・気分・眠気',
              style: TextStyle(
                fontSize: 11,
                color: _mutedColor.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 6),
          for (int i = 0; i < PulseMetric.all.length; i++) ...[
            if (i > 0) const SizedBox(height: observationChartRowGap),
            SizedBox(
              height: _rowExtent,
              child: _ObservationChartRow(
                metric: PulseMetric.all[i],
                values: _valuesFor(sorted, PulseMetric.all[i].id),
                dates: dates,
                lineColor: _chartColors[i],
                labelColor: _labelColor,
                mutedColor: _mutedColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ObservationChartRow extends StatelessWidget {
  const _ObservationChartRow({
    required this.metric,
    required this.values,
    required this.dates,
    required this.lineColor,
    required this.labelColor,
    required this.mutedColor,
  });

  final PulseMetric metric;
  final List<double> values;
  final List<DateTime> dates;
  final Color lineColor;
  final Color labelColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 48,
          child: Text(
            metric.nameJa,
            style: TextStyle(
              fontSize: 13,
              color: labelColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 80),
            child: values.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'データがありません',
                      style: TextStyle(
                        fontSize: 11,
                        color: mutedColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : _MiniChart(
                    values: values,
                    lineColor: lineColor,
                    dates: dates,
                    height: observationChartRowHeight,
                  ),
          ),
        ),
      ],
    );
  }
}

class _HistoryBlock extends StatelessWidget {
  const _HistoryBlock({this.entries});

  final List<DailyStateEntry>? entries;

  static const _chartSpacing = 12.0; // observationHistoryBlockHeight と整合（3本＋間隔で262）
  static const _energyColor = Color(0xFFC2C2C2);
  static const _focusColor = Color(0xFF9A9A9A);
  static const _fatigueColor = Color(0xFF7A7A7A);

  @override
  Widget build(BuildContext context) {
    if (entries == null || entries!.isEmpty) {
      return const SizedBox.shrink();
    }

    final sorted = entries!.toList()..sort((a, b) => a.date.compareTo(b.date));
    final dates = sorted.map((e) => e.date).toList();
    final energyValues = sorted.map((e) => e.energy.value.toDouble()).toList();
    final focusValues = sorted.map((e) => e.focus.value.toDouble()).toList();
    final fatigueValues = sorted.map((e) => e.fatigue.value.toDouble()).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _MiniChart(values: energyValues, lineColor: _energyColor, dates: dates),
        const SizedBox(height: _chartSpacing),
        _MiniChart(values: focusValues, lineColor: _focusColor, dates: dates),
        const SizedBox(height: _chartSpacing),
        _MiniChart(values: fatigueValues, lineColor: _fatigueColor, dates: dates),
      ],
    );
  }
}

class _MiniChart extends StatelessWidget {
  const _MiniChart({
    required this.values,
    required this.lineColor,
    this.dates,
    this.height,
  });

  final List<double> values;
  final Color lineColor;
  final List<DateTime>? dates;
  final double? height;

  static const _chartHeight = 44.0;
  double get _effectiveHeight => height ?? _chartHeight;
  static const _rangeColor = Color(0xFF555555);
  static const _axisColor = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    final leftLabel = dates != null && dates!.isNotEmpty
        ? '${dates!.first.month}/${dates!.first.day}'
        : null;
    final rightLabel = dates != null && dates!.length > 1
        ? '${dates!.last.month}/${dates!.last.day}'
        : (dates != null && dates!.length == 1 ? '${dates!.first.month}/${dates!.first.day}' : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              width: 12,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '5',
                    style: TextStyle(
                      color: _rangeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '1',
                    style: TextStyle(
                      color: _rangeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: _effectiveHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // フォールバック: グラフが描画されない場合でも中央に薄い線を表示
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 1,
                        width: double.infinity,
                        color: lineColor.withOpacity(0.35),
                      ),
                    ),
                    CustomPaint(
                      painter: _LineChartPainter(
                        values: values,
                        lineColor: lineColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (leftLabel != null || rightLabel != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              if (leftLabel != null)
                Text(
                  leftLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    color: _axisColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              const Spacer(),
              if (rightLabel != null && (leftLabel == null || rightLabel != leftLabel))
                Text(
                  rightLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    color: _axisColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
        ],
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
    if (values.isEmpty) return;

    final path = Path();
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    final n = values.length;
    final stepX = (n > 1) ? w / (n - 1) : 0.0;

    for (int i = 0; i < n; i++) {
      final x = (n > 1) ? (i * stepX) : (w * 0.5);
      final y = h - (values[i] - _min) / (_max - _min) * h;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    // 1点だけのときは右端まで横線を引いて「ある」ことを示す
    if (n == 1) {
      final y = h - (values[0] - _min) / (_max - _min) * h;
      path.lineTo(w, y);
    }

    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.lineColor != lineColor;
  }
}
