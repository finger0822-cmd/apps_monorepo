import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_app/core/errors/result.dart';
import 'package:pulse_app/features/pulse/application/providers/pulse_providers.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

/// Insights 画面用の状態・操作。ref.read(usecase) / repository を叩く責務。
class InsightsController {
  InsightsController(this._ref);

  final Ref _ref;

  static List<LocalDate> _last7Days() {
    final now = DateTime.now().toUtc();
    final today = LocalDate.fromDateTime(now);
    return List.generate(7, (i) {
      final dt = DateTime.utc(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - i));
      return LocalDate.fromDateTime(dt);
    });
  }

  /// 保存済みインサイト一覧の先頭を取得。
  Future<Insight?> loadLatest() async {
    final scope = _last7Days();
    if (scope.isEmpty) return null;
    final list = await _ref.read(insightRepositoryProvider).list(scope.first, scope.last);
    return list.isNotEmpty ? list.first : null;
  }

  /// インサイトを生成。Result で返す。
  Future<Result<Insight, String>> generate({required String userId}) {
    return _ref.read(generateInsightsUsecaseProvider).execute(userId: userId);
  }
}
