import 'dart:math' show sqrt;

import 'package:core_state/core_state.dart';

/// Moving average, variance, and trend for a series of 1..5 values.
/// No evaluation - observation only.
class TimeSeriesStats {
  TimeSeriesStats(this.values, {this.window = 3});

  final List<double> values;
  final int window;

  double get mean {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  double get variance {
    if (values.length < 2) return 0;
    final m = mean;
    final sumSq = values.map((v) => (v - m) * (v - m)).reduce((a, b) => a + b);
    return sumSq / (values.length - 1);
  }

  /// Simple trend: second half mean minus first half mean.
  double get trend {
    if (values.length < 2) return 0;
    final half = values.length ~/ 2;
    final first = values.take(half).toList();
    final second = values.skip(half).toList();
    if (first.isEmpty || second.isEmpty) return 0;
    final m1 = first.reduce((a, b) => a + b) / first.length;
    final m2 = second.reduce((a, b) => a + b) / second.length;
    return m2 - m1;
  }

  /// Moving average at each point (same length as values; edges use available points).
  List<double> get movingAverage {
    if (values.isEmpty) return [];
    if (window <= 0) return values.toList();
    final result = <double>[];
    for (int i = 0; i < values.length; i++) {
      final start = (i - window + 1).clamp(0, values.length);
      final end = i + 1;
      final slice = values.sublist(start, end);
      result.add(slice.reduce((a, b) => a + b) / slice.length);
    }
    return result;
  }
}

/// Extract three series (energy, focus, fatigue) from entries and compute basic stats.
StatsResult computeStatsResult(List<DailyStateEntry> entries) {
  if (entries.isEmpty) {
    return StatsResult(
      energy: null,
      focus: null,
      fatigue: null,
      correlationEnergyFocus: null,
      correlationEnergyFatigue: null,
      correlationFocusFatigue: null,
    );
  }

  final sorted = entries.toList()..sort((a, b) => a.date.compareTo(b.date));
  final energy = sorted.map((e) => e.energy.value.toDouble()).toList();
  final focus = sorted.map((e) => e.focus.value.toDouble()).toList();
  final fatigue = sorted.map((e) => e.fatigue.value.toDouble()).toList();

  return StatsResult(
    energy: TimeSeriesStats(energy),
    focus: TimeSeriesStats(focus),
    fatigue: TimeSeriesStats(fatigue),
    correlationEnergyFocus: correlation(energy, focus),
    correlationEnergyFatigue: correlation(energy, fatigue),
    correlationFocusFatigue: correlation(focus, fatigue),
  );
}

/// Pearson correlation between two series of same length.
double? correlation(List<double> a, List<double> b) {
  if (a.length != b.length || a.length < 2) return null;
  final n = a.length;
  final sumA = a.reduce((x, y) => x + y);
  final sumB = b.reduce((x, y) => x + y);
  final sumAB = 0.0 + List.generate(n, (i) => a[i] * b[i]).reduce((x, y) => x + y);
  final sumA2 = a.map((x) => x * x).reduce((x, y) => x + y);
  final sumB2 = b.map((x) => x * x).reduce((x, y) => x + y);
  final num = sumAB - (sumA * sumB / n);
  final den = (sumA2 - sumA * sumA / n) * (sumB2 - sumB * sumB / n);
  if (den <= 0) return null;
  return num / sqrt(den);
}

class StatsResult {
  StatsResult({
    this.energy,
    this.focus,
    this.fatigue,
    this.correlationEnergyFocus,
    this.correlationEnergyFatigue,
    this.correlationFocusFatigue,
  });

  final TimeSeriesStats? energy;
  final TimeSeriesStats? focus;
  final TimeSeriesStats? fatigue;
  final double? correlationEnergyFocus;
  final double? correlationEnergyFatigue;
  final double? correlationFocusFatigue;
}
