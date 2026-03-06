import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

/// インサイトの生成と保存済み一覧。実装は AI（LlmClient）＋Isar で差し替え可能。
abstract class InsightRepository {
  /// 指定範囲のイベントからインサイトを生成し保存して返す。
  Future<Insight> generate(
    LocalDate start,
    LocalDate end,
    List<PulseEvent> events,
  );

  /// 指定範囲の保存済みインサイト一覧を返す（新しい順などは実装依存）。
  Future<List<Insight>> list(LocalDate start, LocalDate end);
}
