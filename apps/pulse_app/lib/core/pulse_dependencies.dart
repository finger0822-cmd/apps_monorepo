import 'package:core_state/core_state.dart';
import 'package:flutter/widgets.dart';

import 'daily_state_upsert_usecase.dart';
import 'repository/isar_state_repository.dart';
import 'isar_provider.dart';

class PulseDependencies {
  final StateRepository<DailyStateEntry> repo;
  final DailyStateUpsertUsecase usecase;

  PulseDependencies({
    required this.repo,
    required this.usecase,
  });

  static Future<PulseDependencies> bootstrap() async {
    WidgetsFlutterBinding.ensureInitialized();

    final isar = await openIsar();
    final repo = IsarStateRepository(isar);
    final usecase = DailyStateUpsertUsecase(repo);

    final entries = await repo.latest(7);
    final stats = StateStatsService().computeStats(entries);
    // ignore: avoid_print
    print('Pulse avgEnergy: ${stats.avgEnergy}');

    return PulseDependencies(repo: repo, usecase: usecase);
  }
}
