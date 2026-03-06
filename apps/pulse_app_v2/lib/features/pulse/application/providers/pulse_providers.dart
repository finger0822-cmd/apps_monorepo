import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_app/core/pulse_dependencies.dart';
import 'package:pulse_app/features/pulse/domain/repositories/insight_repository.dart';
import 'package:pulse_app/features/pulse/domain/usecases/daily_state_upsert_usecase.dart';
import 'package:pulse_app/features/pulse/application/usecases/generate_insights_usecase.dart';
import 'package:pulse_app/features/pulse/application/usecases/get_today_summary_usecase.dart';
import 'package:pulse_app/features/pulse/domain/usecases/log_metric_usecase.dart';

/// 起動時に bootstrap で注入される依存。main で override する。
final pulseDependenciesProvider = Provider<PulseDependencies>((ref) {
  throw UnimplementedError(
    'pulseDependenciesProvider must be overridden in main() with bootstrap result',
  );
});

/// 日次状態の upsert ユースケース。画面から watch して利用する。
final dailyStateUpsertUsecaseProvider = Provider<DailyStateUpsertUsecase>((
  ref,
) {
  return ref.watch(pulseDependenciesProvider).usecase;
});

/// 指標ログのユースケース。
final logMetricUseCaseProvider = Provider<LogMetricUseCase>((ref) {
  return ref.watch(pulseDependenciesProvider).logMetricUseCase;
});

/// インサイトリポジトリ。
final insightRepositoryProvider = Provider<InsightRepository>((ref) {
  return ref.watch(pulseDependenciesProvider).insightRepository;
});

/// AI インサイト生成ユースケース。
final generateInsightsUsecaseProvider = Provider<GenerateInsightsUsecase>((ref) {
  return ref.watch(pulseDependenciesProvider).generateInsightsUsecase;
});

/// 直近インサイト取得ユースケース（Today 画面用）。
final getTodaySummaryUsecaseProvider = Provider<GetTodaySummaryUsecase>((ref) {
  return ref.watch(pulseDependenciesProvider).getTodaySummaryUsecase;
});
