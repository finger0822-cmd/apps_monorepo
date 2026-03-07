import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/insights_provider.dart';
import '../../../../domain/models/diary_entry.dart';

const _bg = Color(0xFF0F0F0F);
const _text = Color(0xFFEAEAEA);
const _sub = Color(0xFF777777);
const _grid = Color(0xFF1A1A1A);
const _lineColor = Color(0xFFEAEAEA);

final _metricLabels = ['気力', '集中', '疲れ', '気分', '眠気'];

double _avg(List<DiaryEntry> entries, int Function(DiaryEntry) selector) {
  if (entries.isEmpty) return 0;
  return entries.map(selector).reduce((a, b) => a + b) / entries.length;
}

/// エントリを日付ごとにグループ化して平均値を計算
List<({DateTime date, double energy, double focus, double fatigue, double mood, double sleepiness})>
    _aggregateByDay(List<DiaryEntry> entries) {
  final Map<String, List<DiaryEntry>> grouped = {};
  for (final e in entries) {
    final key = '${e.createdAt.year}-${e.createdAt.month}-${e.createdAt.day}';
    grouped.putIfAbsent(key, () => []).add(e);
  }
  final result = grouped.entries.map((g) {
    final list = g.value;
    final date = DateTime(
      list.first.createdAt.year,
      list.first.createdAt.month,
      list.first.createdAt.day,
    );
    return (
      date: date,
      energy: list.map((e) => e.energy).reduce((a, b) => a + b) / list.length,
      focus: list.map((e) => e.focus).reduce((a, b) => a + b) / list.length,
      fatigue: list.map((e) => e.fatigue).reduce((a, b) => a + b) / list.length,
      mood: list.map((e) => e.mood).reduce((a, b) => a + b) / list.length,
      sleepiness: list.map((e) => e.sleepiness).reduce((a, b) => a + b) / list.length,
    );
  }).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  return result;
}

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  int _selectedDays = 7;
  static const _periods = [7, 14, 30, 60, 90, 120];

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(insightsEntriesProvider(_selectedDays));

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: _text, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'インサイト',
            style: TextStyle(color: _text, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: _periods.map((period) {
                    final selected = _selectedDays == period;
                    final label = '$period日';
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDays = period),
                      behavior: HitTestBehavior.opaque,
                      child: selected
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Color(0xFFEAEAEA), width: 1),
                                ),
                              ),
                              child: Text(
                                label,
                                style: const TextStyle(color: Color(0xFFEAEAEA), fontSize: 13),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: Text(
                                label,
                                style: const TextStyle(color: Color(0xFF777777), fontSize: 13),
                              ),
                            ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: entriesAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: _text),
                  ),
                  error: (e, st) => Center(
                    child: Text(
                      e.toString(),
                      style: const TextStyle(color: _sub, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  data: (entries) {
                    if (entries.isEmpty) {
                      return const Center(
                        child: Text(
                          'まだデータがありません',
                          style: TextStyle(color: _sub, fontSize: 14),
                        ),
                      );
                    }
                    final aggregated = _aggregateByDay(entries);
                    if (aggregated.isEmpty) {
                      return const Center(
                        child: Text(
                          'まだデータがありません',
                          style: TextStyle(color: _sub, fontSize: 14),
                        ),
                      );
                    }
                    final selectors = <int Function(DiaryEntry)>[
                      (e) => e.energy,
                      (e) => e.focus,
                      (e) => e.fatigue,
                      (e) => e.mood,
                      (e) => e.sleepiness,
                    ];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < 5; i++) ...[
                            Text(
                              _metricLabels[i],
                              style: const TextStyle(
                                color: _text,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              height: 120,
                              child: _MetricLineChart(
                                aggregated: aggregated,
                                metricIndex: i,
                                period: _selectedDays,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 16, left: 24),
                              child: Text(
                                '平均 ${_avg(entries, selectors[i]).toStringAsFixed(1)}',
                                style: const TextStyle(color: Color(0xFF777777), fontSize: 11),
                              ),
                            ),
                          ],
                          _AverageSummary(entries: entries),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _AggregatedDay = ({
  DateTime date,
  double energy,
  double focus,
  double fatigue,
  double mood,
  double sleepiness,
});

class _MetricLineChart extends StatelessWidget {
  const _MetricLineChart({
    required this.aggregated,
    required this.metricIndex,
    required this.period,
  });

  final List<_AggregatedDay> aggregated;
  final int metricIndex;
  final int period;

  double _getValue(_AggregatedDay d) {
    switch (metricIndex) {
      case 0:
        return d.energy;
      case 1:
        return d.focus;
      case 2:
        return d.fatigue;
      case 3:
        return d.mood;
      case 4:
        return d.sleepiness;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spots = aggregated.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), _getValue(e.value)))
        .toList();
    final n = aggregated.length;
    final maxX = n <= 1 ? 1.0 : (n - 1).toDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: 0.5,
        maxY: 5.5,
        backgroundColor: Colors.transparent,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 1,
          verticalInterval: 1,
          getDrawingHorizontalLine: (_) => FlLine(color: _grid, strokeWidth: 1),
          getDrawingVerticalLine: (_) => FlLine(color: _grid, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox.shrink();
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Color(0xFF777777), fontSize: 10),
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= aggregated.length) {
                  return const SizedBox.shrink();
                }
                // period に応じて間引き間隔を変更
                final step = period <= 14
                    ? 1
                    : period <= 30
                        ? 3
                        : period <= 60
                            ? 7
                            : period <= 90
                                ? 10
                                : 14;
                if (index % step != 0 && index != aggregated.length - 1) {
                  return const SizedBox.shrink();
                }
                final date = aggregated[index].date;
                final label = '${date.month}/${date.day.toString().padLeft(2, '0')}';
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(
                    label,
                    style: const TextStyle(color: Color(0xFF777777), fontSize: 9),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: _lineColor,
            barWidth: 1.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 2.5,
                color: _lineColor,
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: const LineTouchData(enabled: false),
      ),
      duration: Duration.zero,
    );
  }
}

class _AverageSummary extends StatelessWidget {
  const _AverageSummary({required this.entries});

  final List<DiaryEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Text(
        '気力 ${_avg(entries, (e) => e.energy).toStringAsFixed(1)}　'
        '集中 ${_avg(entries, (e) => e.focus).toStringAsFixed(1)}　'
        '疲れ ${_avg(entries, (e) => e.fatigue).toStringAsFixed(1)}　'
        '気分 ${_avg(entries, (e) => e.mood).toStringAsFixed(1)}　'
        '眠気 ${_avg(entries, (e) => e.sleepiness).toStringAsFixed(1)}',
        style: const TextStyle(color: Color(0xFF777777), fontSize: 11),
        textAlign: TextAlign.center,
      ),
    );
  }
}
