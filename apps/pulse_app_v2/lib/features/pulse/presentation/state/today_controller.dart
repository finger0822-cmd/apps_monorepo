import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_app/features/pulse/application/providers/pulse_providers.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';

/// Today 画面用の状態・操作。ref.read(usecase) を叩く責務。
class TodayController {
  TodayController(this._ref);

  final Ref _ref;

  /// 直近の AI サマリーを取得。表示用。
  Future<Insight?> loadSummary() {
    return _ref.read(getTodaySummaryUsecaseProvider).execute();
  }
}
