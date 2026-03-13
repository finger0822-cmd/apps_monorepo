import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/models/mind_entry.dart';
import '../settings/settings_provider.dart';
import 'history_detail_screen.dart';
import 'history_provider.dart';

final _dateFormat = DateFormat('yyyy/MM/dd');

const _axisEmojis = ['⚡', '🎯', '😴', '😊', '🌙'];

Color _scoreColor(double avg) {
  if (avg < 2.5) return const Color(0xFFE57373);
  if (avg >= 3.5) return const Color(0xFF66BB6A);
  return const Color(0xFF9E9E9E);
}

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(historyEntriesProvider);
    final lang = ref.watch(appLanguageProvider);
    final s = AppStrings.of(lang);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.historyTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text('${s.historyError}: $e', style: Theme.of(context).textTheme.bodySmall),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📖', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    s.historyEmpty,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    s.historyEmptySubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return _HistoryCard(entry: entry, lang: lang);
            },
          );
        },
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.entry, required this.lang});

  final MindEntry entry;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(lang);
    final axisLabels = s.axisLabelsShort;
    final firstLine = entry.text.split('\n').first.trim();
    final displayText =
        firstLine.length > 80 ? '${firstLine.substring(0, 80)}...' : firstLine;
    final hasFeedback =
        entry.aiFeedback != null && entry.aiFeedback!.isNotEmpty;
    final avg = entry.averageScore;
    final values = [
      entry.energy,
      entry.focus,
      entry.fatigue,
      entry.mood,
      entry.sleepiness,
    ];

    Widget cardContent = Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 上段：日付 + カプセルアイコン + スコアバッジ
          Row(
            children: [
              Text(
                _dateFormat.format(entry.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              if (entry.isTimeCapsule) ...[
                const SizedBox(width: 6),
                const Text('🕰️', style: TextStyle(fontSize: 14)),
              ],
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: _scoreColor(avg),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  avg.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 中段：5軸スコア
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              return Column(
                children: [
                  Text(_axisEmojis[i], style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(
                    '${values[i]}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    axisLabels[i],
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 10),
          // 下段：日記テキスト
          Text(
            displayText.isEmpty ? s.historyNoText : displayText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // AI要約（折りたたみ）
          if (hasFeedback) ...[
            const SizedBox(height: 4),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                leading: const Text('✨', style: TextStyle(fontSize: 14)),
                title: Text(
                  s.historyAiSummary,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6A3DE8),
                      ),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F0FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.aiFeedback!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    // タイムカプセルは左ボーダーつき
    if (entry.isTimeCapsule) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: const Border(
            left: BorderSide(color: Color(0xFF6A3DE8), width: 4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => HistoryDetailScreen(entry: entry),
                ),
              ),
              borderRadius: BorderRadius.circular(16),
              child: cardContent,
            ),
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.black12,
      color: Colors.white,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => HistoryDetailScreen(entry: entry),
          ),
        ),
        borderRadius: BorderRadius.circular(16),
        child: cardContent,
      ),
    );
  }
}
