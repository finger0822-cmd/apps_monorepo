import 'package:core_state/core_state.dart';

import '../statistics/cycle_detector.dart';

/// Result of provisional rhythm detection. Estimation only; no definitive claim.
class ProvisionalRhythmResult {
  const ProvisionalRhythmResult({
    required this.estimatedCycleDays,
    required this.message,
  });

  final int estimatedCycleDays;
  final String message;

  /// Short 1-line label for UI (e.g. "推定リズム：4日").
  String get rhythmLabel => '推定リズム：$estimatedCycleDays日';
}

/// Detects a provisional wave rhythm from 7+ days of entries.
/// Uses autocorrelation (existing cycle_detector). Output uses estimation wording only.
ProvisionalRhythmResult? detectProvisionalRhythm(List<DailyStateEntry> entries) {
  if (entries.length < 7) return null;

  final period = detectEnergyPeriod(entries);
  if (period == null || period < 2 || period > 7) return null;

  final message = _formatMessage(period);
  return ProvisionalRhythmResult(estimatedCycleDays: period, message: message);
}

String _formatMessage(int periodDays) {
  if (periodDays <= 2) {
    return '最近は約${periodDays}日周期の揺れが見られます';
  }
  if (periodDays >= 6) {
    return '${periodDays - 1}〜${periodDays}日のリズムが現れ始めています';
  }
  return '最近は約${periodDays}日周期の揺れがあります';
}
