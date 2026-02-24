import '../model/state_entry.dart';

abstract class StateRepository<T extends StateEntry> {
  Future<T> upsert(T entry);

  Future<T?> findByDate(DateTime date);

  Future<List<T>> findRange(DateTime from, DateTime to);

  Future<List<T>> latest(int count);

  Future<bool> deleteById(String id);
}
