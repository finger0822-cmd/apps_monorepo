import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';
import 'package:pulse_app/features/pulse/domain/repositories/pulse_event_repository.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

/// History は Event から後で組み立てる。設計のみ先行。
/// 指定範囲のイベント一覧を返す（将来: ページング・集計を追加）。
class GetHistoryUsecase {
  GetHistoryUsecase(this._eventRepo);

  final PulseEventRepository _eventRepo;

  Future<List<PulseEvent>> execute({
    required String userId,
    required LocalDate start,
    required LocalDate end,
  }) async {
    final events = <PulseEvent>[];
    var current = start;
    final endDt = DateTime.utc(end.year, end.month, end.day);
    while (true) {
      final list = await _eventRepo.listEvents(userId: userId, date: current);
      events.addAll(list);
      final currentDt = DateTime.utc(current.year, current.month, current.day);
      if (currentDt.isAtSameMomentAs(endDt) || currentDt.isAfter(endDt)) {
        break;
      }
      current = LocalDate.fromDateTime(currentDt.add(const Duration(days: 1)));
    }
    events.sort((a, b) => a.occurredAtUtc.compareTo(b.occurredAtUtc));
    return events;
  }
}
