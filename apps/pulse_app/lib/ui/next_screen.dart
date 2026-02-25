import 'package:core_state/core_state.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../core/aha_prefs.dart';
import '../core/pulse_dependencies.dart';
import '../debug/fake_pulse_history.dart';
import '../domain/insights/header_insight_builder.dart';
import '../domain/insights/rhythm_detector.dart';
import '../domain/metrics/pulse_metric.dart';
import '../l10n/app_localizations.dart';
import 'widgets/home_overflow_menu.dart';
import 'widgets/pulse_line_chart.dart';
import 'widgets/sparkline_wave.dart';
import 'ai_tendency_screen.dart';

/// 2枚目：7〜30日のグラフ観測（観測専用）。5項目を縦並びで表示。入力UIは出さず観測のみ。
// ----- 余白スケール（用途別に参照し、二重取り・過剰を防ぐ）
const double spacingXs = 4.0;
const double spacingSm = 8.0;
const double spacingMd = 12.0;
const double spacingLg = 16.0;

// ----- 観測ブロック内（高さは一箇所で定義し、ブロック全体を算出）
const double observationInternalSpacing = 6.0;
const double observationPeriodLabelToWave = 10.0;
const double observationChartRowHeight = 40.0;   // グラフ描画エリアの高さ
const double observationChartRowExtent = 52.0; // 1行あたりの高さ（ラベル＋グラフ）
const double observationChartRowGap = 10.0;  // 項目間の余白
const double observationChartsBlockHeaderHeight = 23.0; // 見出し＋余白
const double observationChartsBlockDateAxisHeight = 22.0; // 一番下の日付横軸
const double observationChartsBlockHeight = 5 * observationChartRowExtent + 4 * observationChartRowGap + observationChartsBlockHeaderHeight + observationChartsBlockDateAxisHeight; // 323 + 22

// ----- 観測ブロック下 ↔ 「傾向分析を見る」導線の余白（2枚目は観測専用のため入力UIなし）
const double observationToLinkGap = 32.0;
const double linkBottomPadding = 32.0;

// ----- スクロール領域（Padding は上下のみ）
const double scrollTopPadding = 6.0;
const double scrollBottomPadding = 24.0;

// ----- 仮データ（本番が空のとき 7/14/30 日切替に耐えるため）
const int _fakeDays = 120;

List<double> _withFakeIfEmpty(List<double> real, int seed,
    {double base = 0.55, double trend = 0.0}) {
  if (real.isNotEmpty) return real;
  final fake = FakePulseHistory.generate(
    days: _fakeDays,
    seed: seed,
    base: base,
    trend: trend,
    noise: 0.08,
    spikes: 10,
  );
  // グラフは 1〜5 スケールなので 0〜1 を変換
  return fake.map((v) => v * 4 + 1).toList();
}

List<double> _tail(List<double> xs, int n) {
  if (xs.length <= n) return xs;
  return xs.sublist(xs.length - n);
}

/// 眠気グラフ用：表示する横軸ラベルのインデックスを最低2点（できれば3点）に固定。
/// 7日: [0, 3, 6]、14日: [0, 7, 13]、30日: [0, 14, 29]。今日（最後）は必須。
Set<int> _chartAxisVisibleIndices(int periodDays, int total) {
  if (total <= 1) return {};
  final last = total - 1;
  if (periodDays <= 7) {
    if (total <= 3) return {0, last};
    return {0, total ~/ 2, last};
  }
  if (periodDays <= 14) {
    if (total <= 7) return {0, last};
    return {0, 7, last};
  }
  if (total <= 14) return {0, last};
  return {0, 14, last};
}

/// 横軸ラベル用：「N日前」「今日」。visibleIndices が null のときは全インデックス表示（fl_chart の tick に合わせる）。
Widget _chartAxisDayLabel(int index, int total, Set<int>? visibleIndices) {
  if (index < 0 || index >= total) return const SizedBox();
  if (total == 30 && index == total - 2) return const SizedBox();
  if (visibleIndices != null && !visibleIndices.contains(index)) return const SizedBox();
  final daysAgo = total - index;
  final text = daysAgo == 1 ? '今日' : '$daysAgo日前';
  return Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Text(
      text,
      style: const TextStyle(fontSize: 10, color: Color(0x88FFFFFF)),
    ),
  );
}

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

/// データ件数・分散に応じた補助文。必要なときだけ返す。
String? _chartRowHint(List<double> values) {
  if (values.isEmpty || values.length > 6) return null;
  if (values.length >= 2 && values.length <= 3) return '記録が少ないため参考表示';
  if (values.length >= 4) {
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    if (max - min < 0.2) return '変化が小さい／参考表示';
  }
  return null;
}

/// 観測ブロック。解釈・補助・期間切替・期間ラベル・（任意で）グラフを縦積み。
class WaveObservationBlock extends StatelessWidget {
  const WaveObservationBlock({
    super.key,
    required this.entries,
    this.rhythmResult,
    required this.periodDays,
    required this.onPeriodChanged,
    this.showCharts = true,
  });

  final List<DailyStateEntry> entries;
  final ProvisionalRhythmResult? rhythmResult;
  final int periodDays;
  final ValueChanged<int> onPeriodChanged;
  final bool showCharts;

  static const _labelColor = Color(0xFFC2C2C2);
  static const _mutedColor = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    final sorted = entries.isEmpty ? <DailyStateEntry>[] : entries.toList()..sort((a, b) => a.date.compareTo(b.date));
    final energyScores = sorted.map((e) => e.energy.value.toDouble()).toList(growable: false);
    final focusScores = sorted.map((e) => e.focus.value.toDouble()).toList(growable: false);
    final fatigueScores = sorted.map((e) => e.fatigue.value.toDouble()).toList(growable: false);
    final moodScores = sorted
        .where((e) => e.mood != null)
        .map((e) => e.mood!.toDouble())
        .toList(growable: false);
    final sleepScores = sorted
        .where((e) => e.sleepiness != null)
        .map((e) => e.sleepiness!.toDouble())
        .toList(growable: false);

    final rawScores = sorted.map((e) => waveScoreFor(e)).toList();
    final insight = entries.isEmpty ? null : buildHeaderInsight(rawScores, periodDays: periodDays);
    final showInsight = insight != null && insight.message.isNotEmpty;
    final rhythmLabel = rhythmResult != null
        ? '今日のリズム：約${rhythmResult!.estimatedCycleDays}日周期'
        : '今日のリズム：ゆるやか';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. 解釈文（主文1行＋補足は小さく・最大2行）
        if (showInsight)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  insight.message,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: _labelColor.withOpacity(0.95),
                    fontWeight: FontWeight.w400,
                    height: 1.35,
                  ),
                ),
                if (insight.supplement != null && insight.supplement!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    insight.supplement!,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _mutedColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        if (showInsight) const SizedBox(height: observationInternalSpacing),
        // 2. 補助文（1行）＋役割の目安
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
        const SizedBox(height: 2),
        Text(
          '直近の周期感の目安',
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            color: _mutedColor,
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
        if (showCharts) ...[
        const SizedBox(height: observationPeriodLabelToWave),
        // 5. 5項目のグラフ（縦並び）。showCharts が false のときはここは出さない。
        if (entries.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'データがありません',
                style: TextStyle(fontSize: 13, color: Color(0xFF777777), fontWeight: FontWeight.w400),
              ),
            ),
          )
        else ...[
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
          const SizedBox(height: 10),
          PulseLineChart(title: '気力', values: energyScores, lineColor: _labelColor),
          const SizedBox(height: 16),
          PulseLineChart(title: '集中', values: focusScores, lineColor: _labelColor),
          const SizedBox(height: 16),
          PulseLineChart(title: '疲れ', values: fatigueScores, lineColor: _labelColor),
          const SizedBox(height: 16),
          PulseLineChart(title: '気分', values: moodScores, lineColor: _labelColor),
          const SizedBox(height: 16),
          PulseLineChart(title: '眠気', values: sleepScores, lineColor: _labelColor),
          const SizedBox(height: 8),
          _WaveBlockDateAxis(dates: sorted.map((e) => e.date).toList()),
        ],
        ],
      ],
    );
  }
}

/// グラフの一番下に表示する日付の横軸（WaveObservationBlock 用）
class _WaveBlockDateAxis extends StatelessWidget {
  const _WaveBlockDateAxis({required this.dates});

  final List<DateTime> dates;

  @override
  Widget build(BuildContext context) {
    if (dates.isEmpty) return const SizedBox.shrink();
    final n = dates.length;
    final indices = n <= 1 ? <int>[0] : (n <= 3 ? List<int>.generate(n, (i) => i) : <int>[0, n ~/ 2, n - 1]);
    final labels = indices.map((i) {
      final d = dates[i];
      return '${d.month}/${d.day}';
    }).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: labels.map((text) => Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0x88FFFFFF),
            fontWeight: FontWeight.w400,
          ),
        )).toList(),
      ),
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
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 6),
                child: WaveObservationBlock(
                  entries: _entriesForPeriod,
                  rhythmResult: _entriesForPeriod.length >= 7
                      ? detectProvisionalRhythm(_entriesForPeriod)
                      : _rhythmResult,
                  periodDays: _periodDays,
                  onPeriodChanged: (v) => setState(() => _periodDays = v),
                  showCharts: false,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildFiveChartsColumn(),
                ),
              ),
              _BottomNextButton(
                label: l10n.viewTendencyAnalysisLink,
                onPressed: _goToThirdScreen,
              ),
            ],
          ),
        ),
    );
  }

  void _goToThirdScreen() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AiTendencyScreen(deps: widget.deps),
      ),
    );
  }

  Widget _buildFiveChartsColumn() {
    final periodEntries = _entriesForPeriod;
    final sorted = periodEntries.isEmpty
        ? <DailyStateEntry>[]
        : periodEntries.toList()..sort((a, b) => a.date.compareTo(b.date));
    final energyReal = sorted.map((e) => e.energy.value.toDouble()).toList();
    final focusReal = sorted.map((e) => e.focus.value.toDouble()).toList();
    final fatigueReal = sorted.map((e) => e.fatigue.value.toDouble()).toList();
    final moodReal = sorted
        .where((e) => e.mood != null)
        .map((e) => e.mood!.toDouble())
        .toList();
    final sleepReal = sorted
        .where((e) => e.sleepiness != null)
        .map((e) => e.sleepiness!.toDouble())
        .toList();

    final energyFull = _withFakeIfEmpty(energyReal, 101, base: 0.60, trend: 0.06);
    final focusFull = _withFakeIfEmpty(focusReal, 202, base: 0.58, trend: 0.03);
    final fatigueFull = _withFakeIfEmpty(fatigueReal, 303, base: 0.48, trend: -0.02);
    final moodFull = _withFakeIfEmpty(moodReal, 404, base: 0.56, trend: 0.01);
    final sleepFull = _withFakeIfEmpty(sleepReal, 505, base: 0.52, trend: 0.00);

    final n = _periodDays;
    final energyScores = _tail(energyFull, n);
    final focusScores = _tail(focusFull, n);
    final fatigueScores = _tail(fatigueFull, n);
    final moodScores = _tail(moodFull, n);
    final sleepScores = _tail(sleepFull, n);

    return Column(
      children: [
        Expanded(
          child: _MiniMetricChartRow(
            title: '気力',
            values: energyScores,
            showXAxis: false,
          ),
        ),
        Expanded(
          child: _MiniMetricChartRow(
            title: '集中',
            values: focusScores,
            showXAxis: false,
          ),
        ),
        Expanded(
          child: _MiniMetricChartRow(
            title: '疲れ',
            values: fatigueScores,
            showXAxis: false,
          ),
        ),
        Expanded(
          child: _MiniMetricChartRow(
            title: '気分',
            values: moodScores,
            showXAxis: false,
          ),
        ),
        Expanded(
          child: _MiniMetricChartRow(
            title: '眠気',
            values: sleepScores,
            showXAxis: false,
          ),
        ),
        SizedBox(
          height: 32,
          width: double.infinity,
          child: _BottomAxisLabelsRow(
            periodDays: _periodDays,
            total: energyScores.length,
            dates: sorted.map((e) => e.date).toList(),
          ),
        ),
      ],
    );
  }
}

/// 2画面目：5本グラフの直下に表示する横軸ラベル。選択期間（7/14/30日）に合わせて日付（M/d）で表示。
class _BottomAxisLabelsRow extends StatelessWidget {
  const _BottomAxisLabelsRow({
    required this.periodDays,
    required this.total,
    required this.dates,
  });

  final int periodDays;
  final int total;
  final List<DateTime> dates;

  static const _axisColor = Color(0xAAFFFFFF);

  @override
  Widget build(BuildContext context) {
    if (total <= 1) return const SizedBox.shrink();
    // 選択期間に合わせて左・中央・右のインデックス
    final indices = periodDays <= 7
        ? [0, total ~/ 2, total - 1]
        : periodDays <= 14
            ? [0, total ~/ 2, total - 1]
            : [0, total ~/ 2, total - 1];
    // 日付があれば M/d で表示（期間表示と一致）、なければ N日前/今日
    final hasDates = dates.length >= total;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: indices.map((i) {
          final String text = (hasDates && i < dates.length)
              ? '${dates[i].month}/${dates[i].day}'
              : (total - i == 1 ? '今日' : '${total - i}日前');
          return Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: _axisColor,
              fontWeight: FontWeight.w400,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 2画面目下部に常に表示する「傾向分析を見る」ボタン（下固定）。
class _BottomNextButton extends StatelessWidget {
  const _BottomNextButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A2A2A),
              foregroundColor: const Color(0xFFC2C2C2),
              elevation: 0,
            ),
            child: Text(label),
          ),
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

/// 5行表示用の1行。タイトル + 波形（または「データがありません」）。高さは Expanded で均等割り。
class _MiniMetricChartRow extends StatelessWidget {
  const _MiniMetricChartRow({
    required this.title,
    required this.values,
    this.showXAxis = false,
    this.periodDays,
  });

  final String title;
  final List<double> values;
  final bool showXAxis;
  final int? periodDays;

  static const _lineColor = Color(0xFFC2C2C2);
  static const _labelColor = Color(0xFFC2C2C2);
  static const _mutedColor = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    final titleStyle = const TextStyle(
      fontSize: 13,
      color: _labelColor,
      fontWeight: FontWeight.w400,
    );
    final subStyle = const TextStyle(
      fontSize: 11,
      color: _mutedColor,
      fontWeight: FontWeight.w400,
    );
    final hintText = _chartRowHint(values);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(title, style: titleStyle),
              if (hintText != null) ...[
                const SizedBox(width: 6),
                Text(hintText, style: subStyle),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: values.isEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text('データがありません', style: subStyle),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      right: showXAxis ? 10 : 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: values.length <= 1 ? 1.0 : (values.length - 1).toDouble(),
                              minY: 1,
                              maxY: 5,
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineTouchData: const LineTouchData(enabled: false),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  color: _lineColor,
                                  barWidth: 2,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                  spots: values.length == 1
                                      ? [FlSpot(0, values[0]), FlSpot(1, values[0])]
                                      : values
                                          .asMap()
                                          .entries
                                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                                          .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (showXAxis && values.length >= 2)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: SizedBox(
                              height: 22,
                              width: double.infinity,
                              child: _buildBottomAxisLabels(values.length),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// 眠気グラフ用：横軸ラベルを Chart 外で表示（fl_chart の bottomTitles が効かない場合の対策）
  Widget _buildBottomAxisLabels(int total) {
    final indices = periodDays != null && periodDays! <= 7
        ? [0, total ~/ 2, total - 1]
        : periodDays != null && periodDays! <= 14
            ? [0, total - 1]
            : [0, total - 1];
    if (total <= 1 || indices.isEmpty) return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: indices.map((i) {
        final daysAgo = total - i;
        final text = daysAgo == 1 ? '今日' : '$daysAgo日前';
        return Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xAAFFFFFF),
            fontWeight: FontWeight.w400,
          ),
        );
      }).toList(),
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
        return sorted
            .where((e) => e.mood != null)
            .map((e) => e.mood!.toDouble())
            .toList();
      case 'sleepiness':
        return sorted
            .where((e) => e.sleepiness != null)
            .map((e) => e.sleepiness!.toDouble())
            .toList();
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = entries.toList()..sort((a, b) => a.date.compareTo(b.date));
    final dates = sorted.map((e) => e.date).toList();

    return SizedBox(
      height: observationChartsBlockHeight,
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
            RepaintBoundary(
              child: SizedBox(
                height: observationChartRowExtent,
                child: _ObservationChartRow(
                  metric: PulseMetric.all[i],
                  values: _valuesFor(sorted, PulseMetric.all[i].id),
                  dates: dates,
                  lineColor: _chartColors[i],
                  labelColor: _labelColor,
                  mutedColor: _mutedColor,
                ),
              ),
            ),
          ],
          // 一番下に日付の横軸
          SizedBox(
            height: observationChartsBlockDateAxisHeight,
            child: _buildChartsBlockDateAxis(dates),
          ),
        ],
      ),
    );
  }

  /// 5項目グラフの一番下に表示する日付の横軸（左・中央・右の3点）
  Widget _buildChartsBlockDateAxis(List<DateTime> dates) {
    if (dates.isEmpty) return const SizedBox.shrink();
    final n = dates.length;
    final indices = n <= 1 ? [0] : (n <= 3 ? List<int>.generate(n, (i) => i) : [0, n ~/ 2, n - 1]);
    final labels = indices.map((i) {
      final d = dates[i];
      return '${d.month}/${d.day}';
    }).toList();
    // グラフ行と同じ左余白（ラベル幅48 + 間隔8）
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 48 + 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels.map((text) => Text(
                text,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0x88FFFFFF),
                  fontWeight: FontWeight.w400,
                ),
              )).toList(),
            ),
          ),
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
          child: ExcludeSemantics(
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
    // 観測行（height 指定時）は日付ラベルを出さず高さを確定し、オーバーフローを防ぐ
    final showDateLabels = (leftLabel != null || rightLabel != null) && height == null;
    final totalHeight = (_effectiveHeight + (showDateLabels ? 8.0 : 0.0)).clamp(0.0, observationChartRowExtent);

    return SizedBox(
      height: totalHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 12,
                height: _effectiveHeight,
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
        if (showDateLabels) ...[
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
      ),
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
