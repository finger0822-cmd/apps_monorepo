/// 日付正規化・キー生成（純粋な Dart、domain 専用）。
DateTime normalizeToDay(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

String toDateKey(DateTime value) {
  final n = normalizeToDay(value);
  final y = n.year.toString().padLeft(4, '0');
  final m = n.month.toString().padLeft(2, '0');
  final d = n.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
