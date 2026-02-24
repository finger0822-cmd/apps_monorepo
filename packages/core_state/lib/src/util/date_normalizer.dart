DateTime normalizeToDay(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

String toDateKey(DateTime value) {
  final normalized = normalizeToDay(value);
  final y = normalized.year.toString().padLeft(4, '0');
  final m = normalized.month.toString().padLeft(2, '0');
  final d = normalized.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
