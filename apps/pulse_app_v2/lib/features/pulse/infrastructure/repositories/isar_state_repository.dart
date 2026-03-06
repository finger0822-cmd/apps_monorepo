import 'package:core_state/core_state.dart';
import 'package:isar/isar.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/isar/pulse_log_entity.dart';

/// Local persistence implementation of [StateRepository] using Isar.
class IsarStateRepository implements StateRepository<DailyStateEntry> {
  IsarStateRepository(this._isar);

  final Isar _isar;

  static DailyStateEntry _toEntry(PulseLogEntity e) {
    return DailyStateEntry(
      id: e.entryId,
      date: e.date,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
      energy: e.energy,
      focus: e.focus,
      fatigue: e.fatigue,
      mood: e.mood,
      sleepiness: e.sleepiness,
      note: e.note,
    );
  }

  static PulseLogEntity _toEntity(DailyStateEntry entry) {
    return PulseLogEntity()
      ..entryId = entry.id
      ..date = normalizeToDay(entry.date)
      ..createdAt = entry.createdAt
      ..updatedAt = entry.updatedAt
      ..energy = entry.energy.value
      ..focus = entry.focus.value
      ..fatigue = entry.fatigue.value
      ..mood = entry.mood?.value
      ..sleepiness = entry.sleepiness?.value
      ..note = entry.note;
  }

  @override
  Future<DailyStateEntry> upsert(DailyStateEntry entry) async {
    final normalized = normalizeToDay(entry.date);
    final existing = await _isar.pulseLogEntitys
        .filter()
        .entryIdEqualTo(entry.id)
        .findFirst();
    final entity = _toEntity(entry);
    if (existing != null) {
      entity.id = existing.id;
      await _isar.writeTxn(() async {
        await _isar.pulseLogEntitys.put(entity);
      });
    } else {
      final byDate = await _isar.pulseLogEntitys
          .filter()
          .dateEqualTo(normalized)
          .findFirst();
      if (byDate != null) {
        await _isar.writeTxn(() async {
          await _isar.pulseLogEntitys.delete(byDate.id);
        });
      }
      await _isar.writeTxn(() async {
        await _isar.pulseLogEntitys.put(entity);
      });
    }
    return entry;
  }

  @override
  Future<DailyStateEntry?> findByDate(DateTime date) async {
    final day = normalizeToDay(date);
    final e = await _isar.pulseLogEntitys.filter().dateEqualTo(day).findFirst();
    return e == null ? null : _toEntry(e);
  }

  @override
  Future<List<DailyStateEntry>> findRange(DateTime from, DateTime to) async {
    final fromDay = normalizeToDay(from);
    final toDay = normalizeToDay(to);
    if (fromDay.isAfter(toDay)) {
      throw ArgumentError('from must be on or before to.');
    }
    final list = await _isar.pulseLogEntitys
        .where()
        .filter()
        .dateBetween(fromDay, toDay, includeLower: true, includeUpper: true)
        .sortByDate()
        .findAll();
    return list.map(_toEntry).toList();
  }

  @override
  Future<List<DailyStateEntry>> latest(int count) async {
    if (count <= 0) return <DailyStateEntry>[];
    final list = await _isar.pulseLogEntitys
        .where()
        .sortByDateDesc()
        .thenByUpdatedAtDesc()
        .findAll();
    return list.take(count).map(_toEntry).toList();
  }

  @override
  Future<bool> deleteById(String id) async {
    final e = await _isar.pulseLogEntitys
        .filter()
        .entryIdEqualTo(id)
        .findFirst();
    if (e == null) return false;
    await _isar.writeTxn(() async {
      await _isar.pulseLogEntitys.delete(e.id);
    });
    return true;
  }
}
