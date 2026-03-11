import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/api_key_storage.dart';
import '../storage/isar_service.dart';
import '../../data/repositories/entry_repository_impl.dart';
import '../../domain/repositories/entry_repository.dart';
import '../services/claude_service.dart';

/// アプリ全体で使用する EntryRepository のプロバイダー。
/// isarProvider が main で override されていれば、ここから Isar を参照して
/// EntryRepositoryImpl を生成する。
final entryRepositoryProvider = Provider<EntryRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return EntryRepositoryImpl(
    isar: isar,
    claudeService: ClaudeService(),
    apiKeyStorage: ApiKeyStorageImpl(),
  );
});
