import '../model/daily_state_entry.dart';
import '../util/date_normalizer.dart';
import 'state_stats.dart';

class StateStatsService {
  StateStats computeStats(
    List<DailyStateEntry> entries, {
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    final missingDaysCount = _computeMissingDaysCount(
      entries,
      periodStart: periodStart,
      periodEnd: periodEnd,
    );

    if (entries.isEmpty) {
      return StateStats.empty(missingDaysCount: missingDaysCount);
    }

    final sorted = entries.toList()
      ..sort((DailyStateEntry a, DailyStateEntry b) => a.date.compareTo(b.date));

    final energies = sorted.map((e) => e.energy.value).toList();
    final focuses = sorted.map((e) => e.focus.value).toList();
    final fatigues = sorted.map((e) => e.fatigue.value).toList();

    return StateStats(
      avgEnergy: _avg(energies),
      avgFocus: _avg(focuses),
      avgFatigue: _avg(fatigues),
      minEnergy: _min(energies),
      maxEnergy: _max(energies),
      rangeEnergy: _max(energies) - _min(energies),
      minFocus: _min(focuses),
      maxFocus: _max(focuses),
      rangeFocus: _max(focuses) - _min(focuses),
      minFatigue: _min(fatigues),
      maxFatigue: _max(fatigues),
      rangeFatigue: _max(fatigues) - _min(fatigues),
      trendEnergy: _trend(energies),
      trendFocus: _trend(focuses),
      trendFatigue: _trend(fatigues),
      daysCount: sorted.length,
      missingDaysCount: missingDaysCount,
    );
  }

  int _computeMissingDaysCount(
    List<DailyStateEntry> entries, {
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    if (periodStart == null || periodEnd == null) {
      return 0;
    }
    final from = normalizeToDay(periodStart);
    final to = normalizeToDay(periodEnd);
    if (from.isAfter(to)) {
      throw ArgumentError('periodStart must be on or before periodEnd.');
    }

    final spanDays = to.difference(from).inDays + 1;
    final uniqueDays = entries
        .map((e) => normalizeToDay(e.date))
        .where((date) {
          return !date.isBefore(from) && !date.isAfter(to);
        })
        .toSet()
        .length;

    final missing = spanDays - uniqueDays;
    return missing < 0 ? 0 : missing;
  }

  double _avg(List<int> values) {
    if (values.isEmpty) {
      return 0;
    }
    final sum = values.fold<int>(0, (prev, val) => prev + val);
    return sum / values.length;
  }

  int _min(List<int> values) {
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((a, b) => a < b ? a : b);
  }

  int _max(List<int> values) {
    if (values.isEmpty) {
      return 0;
    }
    return values.reduce((a, b) => a > b ? a : b);
  }

  double _trend(List<int> values) {
    if (values.length < 2) {
      return 0;
    }

    final splitIndex = values.length ~/ 2;
    final firstHalf = values.take(splitIndex).toList();
    final secondHalf = values.skip(splitIndex).toList();

    if (firstHalf.isEmpty || secondHalf.isEmpty) {
      return 0;
    }

    return _avg(secondHalf) - _avg(firstHalf);
  }
}
