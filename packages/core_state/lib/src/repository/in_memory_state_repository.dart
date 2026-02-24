import '../model/state_entry.dart';
import '../util/date_normalizer.dart';
import 'state_repository.dart';

class InMemoryStateRepository<T extends StateEntry> implements StateRepository<T> {
  final Map<String, T> _entriesById = <String, T>{};
  final Map<String, String> _idByDateKey = <String, String>{};

  @override
  Future<T> upsert(T entry) async {
    final dateKey = toDateKey(entry.date);

    final existingIdForDate = _idByDateKey[dateKey];
    if (existingIdForDate != null && existingIdForDate != entry.id) {
      _entriesById.remove(existingIdForDate);
    }

    final existingById = _entriesById[entry.id];
    if (existingById != null) {
      final oldDateKey = toDateKey(existingById.date);
      _idByDateKey.remove(oldDateKey);
    }

    _entriesById[entry.id] = entry;
    _idByDateKey[dateKey] = entry.id;
    return entry;
  }

  @override
  Future<T?> findByDate(DateTime date) async {
    final dateKey = toDateKey(date);
    final id = _idByDateKey[dateKey];
    if (id == null) {
      return null;
    }
    return _entriesById[id];
  }

  @override
  Future<List<T>> findRange(DateTime from, DateTime to) async {
    final fromDay = normalizeToDay(from);
    final toDay = normalizeToDay(to);
    if (fromDay.isAfter(toDay)) {
      throw ArgumentError('from must be on or before to.');
    }

    return _entriesById.values.where((T entry) {
      final day = normalizeToDay(entry.date);
      return !day.isBefore(fromDay) && !day.isAfter(toDay);
    }).toList()
      ..sort((T a, T b) => a.date.compareTo(b.date));
  }

  @override
  Future<List<T>> latest(int count) async {
    if (count <= 0) {
      return <T>[];
    }

    final sorted = _entriesById.values.toList()
      ..sort((T a, T b) {
        final dateOrder = b.date.compareTo(a.date);
        if (dateOrder != 0) {
          return dateOrder;
        }
        return b.updatedAt.compareTo(a.updatedAt);
      });

    return sorted.take(count).toList();
  }

  @override
  Future<bool> deleteById(String id) async {
    final existing = _entriesById.remove(id);
    if (existing == null) {
      return false;
    }
    _idByDateKey.remove(toDateKey(existing.date));
    return true;
  }
}
