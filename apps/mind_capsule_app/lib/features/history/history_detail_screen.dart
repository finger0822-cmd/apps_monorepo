import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/mind_entry.dart';

const _metricLabels = ['気力', '集中', '疲れ', '気分', '眠気'];

/// 履歴1件の詳細表示
class HistoryDetailScreen extends StatelessWidget {
  const HistoryDetailScreen({super.key, required this.entry});

  final MindEntry entry;

  static List<int> _values(MindEntry e) => [
    e.energy,
    e.focus,
    e.fatigue,
    e.mood,
    e.sleepiness,
  ];

  @override
  Widget build(BuildContext context) {
    final values = _values(entry);
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text(dateFormat.format(entry.createdAt))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < 5; i++) ...[
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      _metricLabels[i],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${values[i]}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: values[i] / 5,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 16),
            Text('日記', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 6),
            Text(
              entry.text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
            if (entry.aiFeedback != null && entry.aiFeedback!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text('AI要約', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              Text(
                entry.aiFeedback!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
