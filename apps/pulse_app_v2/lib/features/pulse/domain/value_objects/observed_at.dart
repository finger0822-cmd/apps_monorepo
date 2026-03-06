import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

/// 観測日時。deviceTime は UTC 保持（toUtc 前提）。日付集計は [localDate] を使用。
class ObservedAt {
  const ObservedAt({required this.localDate, required this.deviceTime});

  final LocalDate localDate;

  /// UTC で保持する想定。渡す前に [DateTime.toUtc] すること。
  final DateTime deviceTime;

  factory ObservedAt.fromUtc(DateTime utc) {
    return ObservedAt(
      localDate: LocalDate.fromDateTime(utc),
      deviceTime: utc.toUtc(),
    );
  }
}
