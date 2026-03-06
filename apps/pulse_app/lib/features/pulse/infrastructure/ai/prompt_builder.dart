import 'dart:convert';

import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';

/// Builds prompts for weekly insight generation.
/// Does not send raw event payloads; uses _buildSimpleStats instead.
class PromptBuilder {
  PromptBuilder._();
  static const int promptVersion = 1;

  static String buildWeeklyInsightPrompt(
    String userId,
    String rangeKey,
    List<PulseEvent> events,
  ) {
    final stats = _buildSimpleStats(events);
    return 'Generate a weekly insight for user $userId, rangeKey $rangeKey. '
        'Stats (do not expose raw data): ${jsonEncode(stats)}. '
        'Respond with JSON only: {"summary":"string","bullets":["string","string","string"]}';
  }

  static Map<String, dynamic> _buildSimpleStats(List<PulseEvent> events) {
    final byType = <String, int>{};
    final sampleDates = <String>{};
    for (final e in events) {
      byType[e.type] = (byType[e.type] ?? 0) + 1;
      if (sampleDates.length < 5) sampleDates.add(e.localDate);
    }
    return {
      'countByType': byType,
      'totalCount': events.length,
      'sampleDates': sampleDates.toList()..sort(),
    };
  }
}
