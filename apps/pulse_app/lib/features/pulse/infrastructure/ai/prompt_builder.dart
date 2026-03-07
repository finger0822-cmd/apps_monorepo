import 'dart:convert';

import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';
import 'package:pulse_app/features/pulse/infrastructure/ai/pulse_event_stats_builder.dart';

/// Builds prompts for weekly insight generation.
/// Does not send raw event payloads; uses [PulseEventStatsBuilder] for aggregated stats.
class PromptBuilder {
  PromptBuilder._();
  static const int promptVersion = 1;

  static String buildWeeklyInsightPrompt(
    String userId,
    String rangeKey,
    List<PulseEvent> events,
  ) {
    final stats = PulseEventStatsBuilder.build(events);
    return 'Generate a weekly insight for user $userId, rangeKey $rangeKey. '
        'Aggregated stats (no raw payloads). Prefer commenting on trends, not just counts. '
        'Stats: ${jsonEncode(stats)}. '
        'Respond with JSON only: {"summary":"string","bullets":["string","string","string"]}';
  }
}
