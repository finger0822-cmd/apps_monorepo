import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/entry/domain/entry.dart';

final isarProvider = Provider<Isar>(
  (ref) => throw UnimplementedError('Isar is provided from main().'),
);

class IsarService {
  const IsarService._();

  static Future<Isar> open() async {
    if (Isar.instanceNames.isNotEmpty) {
      final existing = Isar.getInstance();
      if (existing != null) {
        return existing;
      }
    }

    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      <CollectionSchema>[EntrySchema],
      directory: dir.path,
    );
  }
}
