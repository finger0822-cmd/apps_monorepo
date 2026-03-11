import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/mind_entry.dart';

/// Isar インスタンスを提供するプロバイダー（main で override して注入）
final isarProvider = Provider<Isar>(
  (ref) => throw UnimplementedError('Isar は main() から注入してください。'),
);

/// Isar DB の初期化・取得を行うサービス
class IsarService {
  const IsarService._();

  /// アプリ用ドキュメントディレクトリで Isar を開く
  static Future<Isar> open() async {
    if (Isar.instanceNames.isNotEmpty) {
      final existing = Isar.getInstance();
      if (existing != null) {
        return existing;
      }
    }

    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      <CollectionSchema>[MindEntrySchema],
      directory: dir.path,
    );
  }
}
