import 'dart:convert';

import '../model/daily_state_entry.dart';
import '../util/date_normalizer.dart';
import '../service/state_stats.dart';
import 'summary_templates.dart';

class SummaryPromptMaterial {
  final String instructionText;
  final String jsonPayload;

  const SummaryPromptMaterial({
    required this.instructionText,
    required this.jsonPayload,
  });
}

class SummaryPromptBuilder {
  SummaryPromptMaterial build({
    required StateStats stats,
    List<DailyStateEntry>? dailySeries,
  }) {
    final payload = <String, Object?>{
      'stats': stats.toJson(),
      'dailySeries': dailySeries == null
          ? <Object>[]
          : dailySeries
              .map(
                (entry) => <String, Object?>{
                  'id': entry.id,
                  'date': toDateKey(entry.date),
                  'energy': entry.energy.value,
                  'focus': entry.focus.value,
                  'fatigue': entry.fatigue.value,
                  'note': entry.note,
                },
              )
              .toList(),
      'outputFormat': <String, Object>{
        'overview': '1-2 lines',
        'observations': '3 bullet points',
        'varianceOrWeekComparison': '1 line',
      },
      'constraints': <String>[
        'no_advice',
        'no_diagnosis',
        'observation_only',
      ],
    };

    return SummaryPromptMaterial(
      instructionText: SummaryTemplates.instructionText,
      jsonPayload: jsonEncode(payload),
    );
  }
}
