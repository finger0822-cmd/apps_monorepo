import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/repositories/insight_repository.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

/// 今日（または直近7日）の範囲で保存済みインサイトの最新1件を返す。Today 画面用。
class GetTodaySummaryUsecase {
  GetTodaySummaryUsecase(this._insightRepo);

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

  /// 直近7日範囲のインサイト一覧の先頭（最新）を返す。なければ null。
  Future<Insight?> execute() async {
    final scope = _last7Days();
    if (scope.isEmpty) return null;
    final list = await _insightRepo.list(scope.first, scope.last);
    return list.isNotEmpty ? list.first : null;
  }
}
