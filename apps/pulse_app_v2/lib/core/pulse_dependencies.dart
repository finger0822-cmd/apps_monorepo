import 'package:core_state/core_state.dart';
import 'package:flutter/widgets.dart';
import 'package:pulse_app/features/pulse/application/usecases/generate_insights_usecase.dart';
import 'package:pulse_app/features/pulse/application/usecases/get_today_summary_usecase.dart';
import 'package:pulse_app/features/pulse/domain/repositories/insight_repository.dart';
import 'package:pulse_app/features/pulse/domain/usecases/daily_state_upsert_usecase.dart';
import 'package:pulse_app/features/pulse/domain/usecases/log_metric_usecase.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/ai/openai_client.dart';
import 'package:pulse_app/features/pulse/infrastructure/repositories/ai_insight_repository.dart';
import 'package:pulse_app/features/pulse/infrastructure/repositories/daily_state_repository_impl.dart';
import 'package:pulse_app/features/pulse/infrastructure/repositories/isar_insight_repository.dart';
import 'package:pulse_app/features/pulse/infrastructure/repositories/isar_pulse_event_repository.dart';
import 'package:pulse_app/features/pulse/infrastructure/repositories/isar_state_repository.dart';

import 'isar_provider.dart';

class PulseDependencies {
  PulseDependencies({
    required this.usecase,
    required this.logMetricUseCase,
    required this.insightRepository,
    required this.generateInsightsUsecase,
    required this.getTodaySummaryUsecase,
  });

  final DailyStateUpsertUsecase usecase;
  final LogMetricUseCase logMetricUseCase;
  final InsightRepository insightRepository;
  final GenerateInsightsUsecase generateInsightsUsecase;
  final GetTodaySummaryUsecase getTodaySummaryUsecase;

  static Future<PulseDependencies> bootstrap() async {
    WidgetsFlutterBinding.ensureInitialized();

    final isar = await openIsar();
    final stateRepo = IsarStateRepository(isar);
    final dailyRepo = DailyStateRepositoryImpl(stateRepo);
    final usecase = DailyStateUpsertUsecase(dailyRepo);
    final eventRepo = IsarPulseEventRepository(isar);
    final logMetricUseCase = LogMetricUseCase(eventRepo: eventRepo);

    final isarInsightStore = IsarInsightRepository(isar);
    final llmClient = OpenAIClient();
    final insightRepo = AiInsightRepository(
      llmClient: llmClient,
      isarStore: isarInsightStore,
    );
    final generateInsightsUsecase = GenerateInsightsUsecase(
      eventRepo: eventRepo,
      insightRepo: insightRepo,
    );
    final getTodaySummaryUsecase = GetTodaySummaryUsecase(insightRepo);

    final entries = await stateRepo.latest(7);
    final stats = StateStatsService().computeStats(entries);
    // ignore: avoid_print
    print('Pulse avgEnergy: ${stats.avgEnergy}');

    return PulseDependencies(
      usecase: usecase,
      logMetricUseCase: logMetricUseCase,
      insightRepository: insightRepo,
      generateInsightsUsecase: generateInsightsUsecase,
      getTodaySummaryUsecase: getTodaySummaryUsecase,
    );
  }
}
