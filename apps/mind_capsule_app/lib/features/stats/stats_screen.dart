import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/services/subscription_service.dart';
import '../settings/settings_provider.dart';
import 'stats_provider.dart';

const _metricLabels = ['気力', '集中', '疲れ', '気分', '眠気'];
const _metricColors = [
  Color(0xFF4CAF50),
  Color(0xFF2196F3),
  Color(0xFFFF9800),
  Color(0xFFE91E63),
  Color(0xFF9C27B0),
];

Color _scoreNumberColor(double score) {
  if (score < 2.5) return const Color(0xFFD32F2F);
  if (score >= 3.5) return const Color(0xFF2E7D32);
  return Colors.grey;
}

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _selectedDays = 7;
  static const _periods = [7, 30, 90, 0]; // 0 = 全期間
  String? _aiAnalysis;
  bool _aiLoading = false;

  @override
  Widget build(BuildContext context) {
    final subAsync = ref.watch(subscriptionProvider);
    final entriesAsync = ref.watch(statsEntriesProvider(_selectedDays));

    return Scaffold(
      appBar: AppBar(
        title: const Text('グラフ'),
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text('エラー: $e', style: Theme.of(context).textTheme.bodySmall),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return Column(
              children: [
                const SizedBox(height: 16),
                _buildPeriodSelector(subAsync),
                const Expanded(child: Center(child: Text('まだデータがありません'))),
              ],
            );
          }
          final aggregated = aggregateByDay(entries);
          if (aggregated.isEmpty) {
            return const Center(child: Text('まだデータがありません'));
          }
          final avgScore = entries
                  .map((e) => e.averageScore)
                  .reduce((a, b) => a + b) /
              entries.length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPeriodSelector(subAsync),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '全体平均スコア',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        avgScore.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: _scoreNumberColor(avgScore),
                        ),
                      ),
                      Text(
                        '（気力・集中・気分は高め、疲れ・眠気は低めが良いスコアです）',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '5軸の推移',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 220,
                child: _StatsLineChart(aggregated: aggregated),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                      5,
                      (i) => Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _metricColors[i],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _metricLabels[i],
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          )),
                ),
              ),
              const SizedBox(height: 24),
              Consumer(builder: (context, ref, _) {
                final sub = ref.watch(subscriptionProvider).valueOrNull;
                final aiLocked = sub != null && !sub.canUseAi;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: aiLocked || _aiLoading
                          ? null
                          : () async {
                              setState(() {
                                _aiLoading = true;
                                _aiAnalysis = null;
                              });
                              final repo = ref.read(entryRepositoryProvider);
                              final lang = ref.read(appLanguageProvider);
                              final entries = await ref.read(
                                  statsEntriesProvider(_selectedDays).future);
                              final ids = entries.map((e) => e.id).toList();
                              final result = await repo.fetchAiPeriodAnalysis(
                                  ids, _selectedDays, lang);
                              ref.read(subscriptionProvider.notifier).incrementAiUsage();
                              setState(() {
                                _aiAnalysis = result;
                                _aiLoading = false;
                              });
                            },
                      icon: _aiLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('✨'),
                      label: Text(aiLocked
                          ? 'AI分析（今月の上限に達しました）'
                          : _aiLoading
                              ? '分析中...'
                              : 'この期間をAIで分析'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A3DE8),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (_aiAnalysis != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F0FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _aiAnalysis!,
                          style: const TextStyle(height: 1.6),
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPeriodSelector(AsyncValue<SubscriptionState> subAsync) {
    final sub = subAsync.valueOrNull;
    return SegmentedButton<int>(
      segments: _periods.map((d) {
        final label = d == 0 ? '全期間' : '$d日';
        final locked = sub != null && !sub.canUsePeriod(d);
        return ButtonSegment<int>(
          value: d,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              if (locked) ...[
                const SizedBox(width: 4),
                const Icon(Icons.lock_outline, size: 12),
              ],
            ],
          ),
          enabled: !locked,
        );
      }).toList(),
      selected: {_selectedDays},
      onSelectionChanged: (s) => setState(() {
        _selectedDays = s.first;
        _aiAnalysis = null;
      }),
    );
  }
}

class _StatsLineChart extends StatelessWidget {
  const _StatsLineChart({required this.aggregated});

  final List<StatsDayData> aggregated;

  double _getValue(StatsDayData d, int index) {
    switch (index) {
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
    final n = aggregated.length;
    final maxX = n <= 1 ? 1.0 : (n - 1).toDouble();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: maxX,
        minY: 0.5,
        maxY: 5.5,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Theme.of(context)
                .colorScheme
                .outline
                .withValues(alpha: 0.3),
            strokeWidth: 1,
          ),
          getDrawingVerticalLine: (_) => FlLine(
            color: Theme.of(context)
                .colorScheme
                .outline
                .withValues(alpha: 0.3),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    value.toInt().toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                final step = n > 14 ? (n / 7).ceil() : 1;
                if (step > 1 && index % step != 0 && index != n - 1) {
                  return const SizedBox.shrink();
                }
                final date = aggregated[index].date;
                final label = '${date.month}/${date.day}';
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: List.generate(5, (i) {
          final spots = aggregated
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), _getValue(e.value, i)))
              .toList();
          return LineChartBarData(
            spots: spots,
            isCurved: true,
            color: _metricColors[i],
            barWidth: 2.5,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: _metricColors[i],
                strokeWidth: 0,
              ),
            ),
            belowBarData: BarAreaData(show: false),
          );
        }),
        lineTouchData: const LineTouchData(enabled: false),
      ),
      duration: Duration.zero,
    );
  }
}
