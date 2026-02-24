import 'package:core_state/core_state.dart';

import '../statistics/cycle_detector.dart';
import '../statistics/time_series_stats.dart';

/// Interface for generating insight text from entries.
/// Template implementation now; LLM can be swapped in later.
abstract class InsightGenerator {
  String generate(List<DailyStateEntry> entries);
}

/// Template-based insight. No diagnosis, no encouragement, weather-report tone.
class TemplateInsightGenerator implements InsightGenerator {
  @override
  String generate(List<DailyStateEntry> entries) {
    if (entries.isEmpty) return '';

    final result = computeStatsResult(entries);
    final period = detectEnergyPeriod(entries);

    if (period != null && period >= 2 && period <= 7) {
      return '最近は$period〜${period + 1}日ごとに波が来る傾向があります。';
    }

    if (result.energy != null && result.energy!.trend < -0.3) {
      if (result.energy!.values.length >= 5) {
        return '過去の傾向では、明日は少し低くなりやすい日かもしれません。';
      }
      return 'ここ数日は少し下がり気味です。';
    }

    if (result.correlationEnergyFocus != null &&
        result.correlationEnergyFocus! > 0.5) {
      return '体力と集中は連動しやすい傾向があります。';
    }

    if (result.energy != null && result.energy!.values.length >= 3) {
      return '今日はゆっくりで十分です。';
    }

    return '';
  }
}

/// Convenience: generate one-line insight with default template generator.
String generateInsightText(List<DailyStateEntry> entries) {
  return TemplateInsightGenerator().generate(entries);
}
