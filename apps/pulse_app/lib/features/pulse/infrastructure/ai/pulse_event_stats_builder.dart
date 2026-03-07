import 'dart:convert';

import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';

/// Builds aggregated stats from [PulseEvent] list for AI prompt context.
/// Does not include raw payloads; decode errors are skipped per event.
class PulseEventStatsBuilder {
  PulseEventStatsBuilder._();

  /// Builds a [Map] of stats from [events]. Keys with no data are omitted.
  static Map<String, dynamic> build(List<PulseEvent> events) {
    if (events.isEmpty) {
      return {'totalEventCount': 0};
    }

    final result = <String, dynamic>{
      'totalEventCount': events.length,
    };

    // byTypeCount
    final byTypeCount = <String, int>{};
    for (final e in events) {
      byTypeCount[e.type] = (byTypeCount[e.type] ?? 0) + 1;
    }
    result['byTypeCount'] = byTypeCount;

    // uniqueLocalDateCount, sampleDays, dailyCounts, streakDays
    final localDates = events.map((e) => e.localDate).toSet().toList()..sort();
    result['uniqueLocalDateCount'] = localDates.length;
    result['sampleDays'] = localDates.take(5).toList();

    final dailyCounts = <String, int>{};
    for (final e in events) {
      dailyCounts[e.localDate] = (dailyCounts[e.localDate] ?? 0) + 1;
    }
    result['dailyCounts'] = dailyCounts;

    result['streakDays'] = _computeStreakDays(localDates);

    // Parse payloads once and collect numeric + hour
    final sleepHours = <double>[];
    final moods = <double>[];
    final focusList = <double>[];
    final energyList = <double>[];
    final timeOfDayLabels = <String>[];

    for (final e in events) {
      Map<String, dynamic>? payload;
      try {
        final decoded = jsonDecode(e.payloadJson);
        if (decoded is! Map<String, dynamic>) continue;
        payload = decoded;
      } catch (_) {
        continue;
      }

      final sleep = _toDouble(payload['sleepHours']);
      final mood = _toDouble(payload['mood']);
      final focus = _toDouble(payload['focus']);
      final energy = _toDouble(payload['energy']);
      if (sleep != null) sleepHours.add(sleep);
      if (mood != null) moods.add(mood);
      if (focus != null) focusList.add(focus);
      if (energy != null) energyList.add(energy);

      final hour = _getLocalHour(payload, e.occurredAtUtc);
      if (hour != null) {
        timeOfDayLabels.add(_hourToTimeOfDay(hour));
      }
    }

    // sleepHours / mood / focus / energy avg, min, max
    _addMetricStats(result, 'sleepHours', sleepHours);
    _addMetricStats(result, 'mood', moods);
    _addMetricStats(result, 'focus', focusList);
    _addMetricStats(result, 'energy', energyList);

    // timeOfDayCounts
    if (timeOfDayLabels.isNotEmpty) {
      final timeOfDayCounts = <String, int>{};
      for (final label in timeOfDayLabels) {
        timeOfDayCounts[label] = (timeOfDayCounts[label] ?? 0) + 1;
      }
      result['timeOfDayCounts'] = timeOfDayCounts;
    }

    // recentTrend: firstHalfAvg, secondHalfAvg, delta (mood/focus/energy)
    final trend = _buildRecentTrend(events, moods, focusList, energyList);
    if (trend.isNotEmpty) result['recentTrend'] = trend;

    return result;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int? _getLocalHour(Map<String, dynamic> payload, DateTime occurredAtUtc) {
    final recorded = payload['recordedAtLocalHour'];
    if (recorded != null) {
      if (recorded is int && recorded >= 0 && recorded <= 23) return recorded;
      if (recorded is double && recorded >= 0 && recorded < 24) return recorded.toInt();
      final s = recorded is String ? int.tryParse(recorded) : null;
      if (s != null && s >= 0 && s <= 23) return s;
    }
    return occurredAtUtc.toLocal().hour;
  }

  static String _hourToTimeOfDay(int hour) {
    if (hour >= 6 && hour <= 11) return 'morning';
    if (hour >= 12 && hour <= 17) return 'afternoon';
    if (hour >= 18 && hour <= 21) return 'evening';
    return 'night';
  }

  static void _addMetricStats(
    Map<String, dynamic> result,
    String prefix,
    List<double> values,
  ) {
    if (values.isEmpty) return;
    result['${prefix}Avg'] = values.reduce((a, b) => a + b) / values.length;
    result['${prefix}Min'] = values.reduce((a, b) => a < b ? a : b);
    result['${prefix}Max'] = values.reduce((a, b) => a > b ? a : b);
  }

  static int _computeStreakDays(List<String> sortedUniqueDates) {
    if (sortedUniqueDates.isEmpty) return 0;
    int maxStreak = 1;
    int current = 1;
    for (int i = 1; i < sortedUniqueDates.length; i++) {
      final prev = DateTime.parse(sortedUniqueDates[i - 1]);
      final curr = DateTime.parse(sortedUniqueDates[i]);
      final diff = curr.difference(prev).inDays;
      if (diff == 1) {
        current++;
      } else {
        if (current > maxStreak) maxStreak = current;
        current = 1;
      }
    }
    if (current > maxStreak) maxStreak = current;
    return maxStreak;
  }

  static Map<String, dynamic> _buildRecentTrend(
    List<PulseEvent> events,
    List<double> moods,
    List<double> focusList,
    List<double> energyList,
  ) {
    final localDates = events.map((e) => e.localDate).toSet().toList()..sort();
    if (localDates.length < 2) return {};

    final mid = localDates.length ~/ 2;
    final firstHalfDates = localDates.take(mid).toSet();
    final secondHalfDates = localDates.skip(mid).toSet();

    final firstHalfValues = <double>[];
    final secondHalfValues = <double>[];

    for (final e in events) {
      Map<String, dynamic>? payload;
      try {
        final decoded = jsonDecode(e.payloadJson);
        if (decoded is! Map<String, dynamic>) continue;
        payload = decoded;
      } catch (_) {
        continue;
      }
      final mood = _toDouble(payload['mood']);
      final focus = _toDouble(payload['focus']);
      final energy = _toDouble(payload['energy']);
      final inFirst = firstHalfDates.contains(e.localDate);
      final inSecond = secondHalfDates.contains(e.localDate);
      if (inFirst) {
        if (mood != null) firstHalfValues.add(mood);
        if (focus != null) firstHalfValues.add(focus);
        if (energy != null) firstHalfValues.add(energy);
      } else if (inSecond) {
        if (mood != null) secondHalfValues.add(mood);
        if (focus != null) secondHalfValues.add(focus);
        if (energy != null) secondHalfValues.add(energy);
      }
    }

    if (firstHalfValues.isEmpty || secondHalfValues.isEmpty) return {};

    final firstHalfAvg =
        firstHalfValues.reduce((a, b) => a + b) / firstHalfValues.length;
    final secondHalfAvg =
        secondHalfValues.reduce((a, b) => a + b) / secondHalfValues.length;
    final delta = secondHalfAvg - firstHalfAvg;

    return {
      'firstHalfAvg': firstHalfAvg,
      'secondHalfAvg': secondHalfAvg,
      'delta': delta,
    };
  }
}
