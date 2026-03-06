import 'package:pulse_app/core/errors/result.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';
import 'package:pulse_app/features/pulse/domain/repositories/insight_repository.dart';
import 'package:pulse_app/features/pulse/domain/repositories/pulse_event_repository.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

/// 直近7日分のイベントから AI インサイトを生成する。Repository 経由で差し替え可能。
class GenerateInsightsUsecase {
  GenerateInsightsUsecase({
    required PulseEventRepository eventRepo,
    required InsightRepository insightRepo,
  })  : _eventRepo = eventRepo,
        _insightRepo = insightRepo;

  final PulseEventRepository _eventRepo;
  final InsightRepository _insightRepo;

  static List<LocalDate> _last7Days() {
    final now = DateTime.now().toUtc();
    final today = LocalDate.fromDateTime(now);
    return List.generate(7, (i) {
      final dt = DateTime.utc(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - i));
      return LocalDate.fromDateTime(dt);
    });
  }

  /// インサイトを生成し保存する。[userId] でイベントを取得。
  /// 戻り: [Result.success] に [Insight]、失敗時は [Result.failure] にメッセージ。
  Future<Result<Insight, String>> execute({required String userId}) async {
    final scopeDates = _last7Days();
    final scopeStart = scopeDates.first;
    final scopeEnd = scopeDates.last;

    try {
      final allEvents = <PulseEvent>[];
      for (final date in scopeDates) {
        final list = await _eventRepo.listEvents(userId: userId, date: date);
        allEvents.addAll(list);
      }
      final insight = await _insightRepo.generate(scopeStart, scopeEnd, allEvents);
      return Success(insight);
    } catch (e) {
      return Failure('生成に失敗しました: $e');
    }
  }
}
