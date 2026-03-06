/// 年月日。日付集計はこれを使用。DateTime の日付部分のみ利用する想定。
class LocalDate {
  const LocalDate({required this.year, required this.month, required this.day});

  final int year;
  final int month;
  final int day;

  /// DateTime から日付部分のみを取り出して生成。
  factory LocalDate.fromDateTime(DateTime dt) {
    final utc = dt.toUtc();
    return LocalDate(year: utc.year, month: utc.month, day: utc.day);
  }
}
