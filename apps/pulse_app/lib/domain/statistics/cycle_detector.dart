import 'dart:math' show sqrt;

import 'package:core_state/core_state.dart';

/// Simple period detection via autocorrelation (lag 1..maxLag).
/// Returns approximate period in days if a peak is found; null otherwise.
/// Prioritizes "something that works" over precision.
int? detectPeriodDays(List<double> values, {int maxLag = 7}) {
  if (values.length < maxLag * 2) return null;

  final mean = values.reduce((a, b) => a + b) / values.length;
  final centered = values.map((v) => v - mean).toList();

  double maxCorr = -2;
  int bestLag = 0;

  for (int lag = 1; lag <= maxLag && lag < centered.length ~/ 2; lag++) {
    double sum = 0;
    double normA = 0;
    double normB = 0;
    final n = centered.length - lag;
    for (int i = 0; i < n; i++) {
      sum += centered[i] * centered[i + lag];
      normA += centered[i] * centered[i];
      normB += centered[i + lag] * centered[i + lag];
    }
    if (normA <= 0 || normB <= 0) continue;
    final r = sum / (sqrt(normA) * sqrt(normB));
    if (r > maxCorr) {
      maxCorr = r;
      bestLag = lag;
    }
  }

  if (bestLag == 0 || maxCorr < 0.3) return null;
  return bestLag;
}

/// Runs period detection on energy series from entries.
int? detectEnergyPeriod(List<DailyStateEntry> entries) {
  if (entries.length < 6) return null;
  final sorted = entries.toList()..sort((a, b) => a.date.compareTo(b.date));
  final series = sorted.map((e) => e.energy.value.toDouble()).toList();
  return detectPeriodDays(series);
}
