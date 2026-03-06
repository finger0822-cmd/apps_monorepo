import 'package:core_state/core_state.dart';
import 'package:flutter/widgets.dart';

import '../data/repositories/isar_pulse_event_repository.dart';
import '../application/usecases/log_metric_usecase.dart';
import 'daily_state_upsert_usecase.dart';
import 'repository/isar_state_repository.dart';
import 'isar_provider.dart';

class PulseDependencies {
  final StateRepository<DailyStateEntry> repo;
  final DailyStateUpsertUsecase usecase;
  final LogMetricUseCase logMetricUseCase;

  PulseDependencies({
    required this.repo,
    required this.usecase,
    required this.logMetricUseCase,
  });

  static Future<PulseDependencies> bootstrap() async {
    WidgetsFlutterBinding.ensureInitialized();

    final isar = await openIsar();
    final repo = IsarStateRepository(isar);
    final usecase = DailyStateUpsertUsecase(repo);
    final eventRepo = IsarPulseEventRepository(isar);
    final logMetricUseCase = LogMetricUseCase(eventRepo: eventRepo);

    final entries = await repo.latest(7);
    final stats = StateStatsService().computeStats(entries);
    // ignore: avoid_print
    print('Pulse avgEnergy: ${stats.avgEnergy}');

    return PulseDependencies(
      repo: repo,
      usecase: usecase,
      logMetricUseCase: logMetricUseCase,
    );
  }
}
