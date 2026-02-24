import 'package:core_state/core_state.dart';

/// Returns entries for the week that contains [date].
/// Week is Monday–Sunday; [date] is normalized to day.
Future<List<DailyStateEntry>> getWeekEntries(
  StateRepository<DailyStateEntry> repo,
  DateTime date,
) async {
  final day = normalizeToDay(date);
  final weekday = day.weekday;
  final monday = day.subtract(Duration(days: weekday - 1));
  final sunday = monday.add(const Duration(days: 6));
  return repo.findRange(monday, sunday);
}
