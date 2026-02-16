import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';

import '../../../core/storage/isar_service.dart';
import '../domain/entry.dart';

final entryRepositoryProvider = Provider<EntryRepository>(
  (ref) => EntryRepository(ref.watch(isarProvider)),
);

final allEntriesProvider = FutureProvider<List<Entry>>(
  (ref) => ref.watch(entryRepositoryProvider).fetchAllDesc(),
);

final entryByIdProvider = FutureProvider.family<Entry?, int>(
  (ref, id) => ref.watch(entryRepositoryProvider).findById(id),
);

class EntryRepository {
  EntryRepository(this._isar);

  final Isar _isar;

  String dateKeyOf(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<Entry?> findByDate(String dateKey) {
    return _isar.entrys.filter().dateEqualTo(dateKey).findFirst();
  }

  Future<Entry?> findToday() {
    return findByDate(dateKeyOf(DateTime.now()));
  }

  Future<Entry?> findById(int id) {
    return _isar.entrys.get(id);
  }

  Future<List<Entry>> fetchAllDesc() async {
    final entries = await _isar.entrys.where().sortByCreatedAtDesc().findAll();
    return entries;
  }

  Future<void> upsertToday(String text) async {
    final now = DateTime.now();
    final dateKey = dateKeyOf(now);
    final entry = Entry(date: dateKey, text: text, createdAt: now);
    await _isar.writeTxn(() async {
      await _isar.entrys.put(entry);
    });
  }
}
