import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/secure_storage/api_key_secure_storage.dart';
import '../../../../core/services/claude_api_service.dart';
import '../../../../core/storage/isar_service.dart';
import '../../../../domain/repositories/ai_feedback_repository.dart';
import '../../../../infrastructure/ai_feedback_repository_impl.dart';

final _apiKeySecureStorageProvider = Provider<ApiKeySecureStorage>((ref) {
  return ApiKeySecureStorageImpl();
});

final _claudeApiServiceProvider = Provider<ClaudeApiService>((ref) {
  return ClaudeApiService();
});

/// Provides [AiFeedbackRepository] (domain interface) implemented by infrastructure.
final aiFeedbackRepositoryProvider = Provider<AiFeedbackRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final apiService = ref.watch(_claudeApiServiceProvider);
  final apiKeyStorage = ref.watch(_apiKeySecureStorageProvider);
  return AiFeedbackRepositoryImpl(
    isar: isar,
    apiService: apiService,
    apiKeyStorage: apiKeyStorage,
  );
});

/// Provides AI feedback for a diary entry.
/// Key is (entryId, language) where language is 'ja' or 'en'.
final aiFeedbackProvider =
    FutureProvider.family<String?, (int entryId, String language)>(
  (ref, key) async {
    final repository = ref.watch(aiFeedbackRepositoryProvider);
    return repository.getFeedback(key.$1, key.$2);
  },
);
