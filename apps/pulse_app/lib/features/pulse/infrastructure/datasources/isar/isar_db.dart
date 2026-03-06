import 'package:isar/isar.dart';

/// Singleton holder for the app's Isar instance.
/// Set via [setInstance] during bootstrap (e.g. after openIsar() with extraSchemas).
/// Do not open Isar here; use the same instance opened in core/isar_provider.
class IsarDb {
  IsarDb._();

  static Isar? _instance;

  static void setInstance(Isar isar) {
    _instance = isar;
  }

  static Isar getInstance() {
    final i = _instance;
    if (i == null) {
      throw StateError('IsarDb not initialized. Call IsarDb.setInstance(isar) after openIsar().');
    }
    return i;
  }
}
