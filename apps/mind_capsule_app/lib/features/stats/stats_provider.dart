import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/app_providers.dart';
import '../../domain/models/mind_entry.dart';

/// 指定日数分のエントリを取得（日付昇順でグラフ用）
/// days = 0 のとき全期間
final statsEntriesProvider = FutureProvider.family<List<MindEntry>, int>((
  ref,
  days,
) async {
  final repo = ref.watch(entryRepositoryProvider);
  List<MindEntry> list;
  if (days == 0) {
    list = await repo.getAll();
  } else {
    final limit = days * 2;
    list = await repo.getRecent(limit);
    final since = DateTime.now().subtract(Duration(days: days));
    list = list.where((e) => !e.createdAt.isBefore(since)).toList();
  }
  list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
  return list;
});

/// 日付ごとに集約したデータ（1日複数件は平均）
class StatsDayData {
  const StatsDayData({
    required this.date,
    required this.energy,
    required this.focus,
    required this.fatigue,
    required this.mood,
    required this.sleepiness,
    required this.averageScore,
  });
  final DateTime date;
  final double energy;
  final double focus;
  final double fatigue;
  final double mood;
  final double sleepiness;
  final double averageScore;
}

/// 日付でグループ化して1日あたりの平均を計算
List<StatsDayData> aggregateByDay(List<MindEntry> entries) {
  final grouped = <String, List<MindEntry>>{};
  for (final e in entries) {
    final key = '${e.createdAt.year}-${e.createdAt.month}-${e.createdAt.day}';
    grouped.putIfAbsent(key, () => []).add(e);
  }
  final result = grouped.entries.map((g) {
    final list = g.value;
    final date = DateTime(
      list.first.createdAt.year,
      list.first.createdAt.month,
      list.first.createdAt.day,
    );
    final energy =
        list.map((e) => e.energy).reduce((a, b) => a + b) / list.length;
    final focus =
        list.map((e) => e.focus).reduce((a, b) => a + b) / list.length;
    final fatigue =
        list.map((e) => e.fatigue).reduce((a, b) => a + b) / list.length;
    final mood = list.map((e) => e.mood).reduce((a, b) => a + b) / list.length;
    final sleepiness =
        list.map((e) => e.sleepiness).reduce((a, b) => a + b) / list.length;
    final avg =
        list.map((e) => e.averageScore).reduce((a, b) => a + b) / list.length;
    return StatsDayData(
      date: date,
      energy: energy,
      focus: focus,
      fatigue: fatigue,
      mood: mood,
      sleepiness: sleepiness,
      averageScore: avg,
    );
  }).toList();
  result.sort((a, b) => a.date.compareTo(b.date));
  return result;
}

/// 週ごとに集約（90日用）
List<StatsDayData> aggregateByWeek(List<MindEntry> entries) {
  final grouped = <String, List<MindEntry>>{};
  for (final e in entries) {
    final d = e.createdAt;
    final weekStart = d.subtract(Duration(days: d.weekday - 1));
    final key = '${weekStart.year}-${weekStart.month}-${weekStart.day}';
    grouped.putIfAbsent(key, () => []).add(e);
  }
  final result = grouped.entries.map((g) {
    final list = g.value;
    final parts = g.key.split('-');
    final date = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final energy =
        list.map((e) => e.energy).reduce((a, b) => a + b) / list.length;
    final focus =
        list.map((e) => e.focus).reduce((a, b) => a + b) / list.length;
    final fatigue =
        list.map((e) => e.fatigue).reduce((a, b) => a + b) / list.length;
    final mood = list.map((e) => e.mood).reduce((a, b) => a + b) / list.length;
    final sleepiness =
        list.map((e) => e.sleepiness).reduce((a, b) => a + b) / list.length;
    final avg =
        list.map((e) => e.averageScore).reduce((a, b) => a + b) / list.length;
    return StatsDayData(
      date: date,
      energy: energy,
      focus: focus,
      fatigue: fatigue,
      mood: mood,
      sleepiness: sleepiness,
      averageScore: avg,
    );
  }).toList();
  result.sort((a, b) => a.date.compareTo(b.date));
  return result;
}

/// 月ごとに集約（全期間用）
List<StatsDayData> aggregateByMonth(List<MindEntry> entries) {
  final grouped = <String, List<MindEntry>>{};
  for (final e in entries) {
    final key = '${e.createdAt.year}-${e.createdAt.month}';
    grouped.putIfAbsent(key, () => []).add(e);
  }
  final result = grouped.entries.map((g) {
    final list = g.value;
    final parts = g.key.split('-');
    final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), 1);
    final energy =
        list.map((e) => e.energy).reduce((a, b) => a + b) / list.length;
    final focus =
        list.map((e) => e.focus).reduce((a, b) => a + b) / list.length;
    final fatigue =
        list.map((e) => e.fatigue).reduce((a, b) => a + b) / list.length;
    final mood = list.map((e) => e.mood).reduce((a, b) => a + b) / list.length;
    final sleepiness =
        list.map((e) => e.sleepiness).reduce((a, b) => a + b) / list.length;
    final avg =
        list.map((e) => e.averageScore).reduce((a, b) => a + b) / list.length;
    return StatsDayData(
      date: date,
      energy: energy,
      focus: focus,
      fatigue: fatigue,
      mood: mood,
      sleepiness: sleepiness,
      averageScore: avg,
    );
  }).toList();
  result.sort((a, b) => a.date.compareTo(b.date));
  return result;
}
