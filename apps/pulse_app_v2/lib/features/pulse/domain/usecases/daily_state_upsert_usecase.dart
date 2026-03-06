import 'package:pulse_app/features/pulse/domain/entities/daily_state.dart';
import 'package:pulse_app/features/pulse/domain/repositories/daily_state_repository.dart';
import 'package:pulse_app/features/pulse/domain/utils/date_utils.dart';

class DailyStateUpsertUsecase {
  DailyStateUpsertUsecase(this.repo, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;

  final DailyStateRepository repo;
  final DateTime Function() clock;

  Future<DailyState> upsertForDate({
    required DateTime date,
    required int energy,
    required int focus,
    required int fatigue,
    required int mood,
    required int sleepiness,
    String? note,
    bool clearNote = false,
    String Function(DateTime normalizedDate)? idFactory,
  }) async {
    final normalizedDate = normalizeToDay(date);
    final now = clock();
    final existing = await repo.findByDate(normalizedDate);

    if (existing != null) {
      final updated = existing.copyWith(
        date: normalizedDate,
        updatedAt: now,
        energy: energy,
        focus: focus,
        fatigue: fatigue,
        mood: mood,
        sleepiness: sleepiness,
        note: note,
        clearNote: clearNote,
      );
      return repo.upsert(updated);
    }

    final resolvedIdFactory = idFactory ?? _defaultIdFactory;
    final created = DailyState(
      id: resolvedIdFactory(normalizedDate),
      date: normalizedDate,
      createdAt: now,
      updatedAt: now,
      energy: energy,
      focus: focus,
      fatigue: fatigue,
      mood: mood,
      sleepiness: sleepiness,
      note: clearNote ? null : note,
    );
    return repo.upsert(created);
  }

  String _defaultIdFactory(DateTime normalizedDate) {
    return 'daily_${toDateKey(normalizedDate)}';
  }
}
