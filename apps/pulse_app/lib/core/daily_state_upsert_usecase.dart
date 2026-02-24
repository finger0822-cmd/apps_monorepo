import 'package:core_state/core_state.dart';

class DailyStateUpsertUsecase {
  DailyStateUpsertUsecase(this.repo, {DateTime Function()? clock})
    : clock = clock ?? DateTime.now;

  final StateRepository<DailyStateEntry> repo;
  final DateTime Function() clock;

  Future<DailyStateEntry> upsertForDate({
    required DateTime date,
    required int energy,
    required int focus,
    required int fatigue,
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
        note: note,
        clearNote: clearNote,
      );
      return repo.upsert(updated);
    }

    final resolvedIdFactory = idFactory ?? _defaultIdFactory;
    final created = DailyStateEntry(
      id: resolvedIdFactory(normalizedDate),
      date: normalizedDate,
      createdAt: now,
      updatedAt: now,
      energy: energy,
      focus: focus,
      fatigue: fatigue,
      note: clearNote ? null : note,
    );
    return repo.upsert(created);
  }

  String _defaultIdFactory(DateTime normalizedDate) {
    return 'daily_${toDateKey(normalizedDate)}';
  }
}
