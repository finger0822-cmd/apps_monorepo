import 'package:isar/isar.dart';

import '../core/secure_storage/api_key_secure_storage.dart';
import '../core/services/claude_api_service.dart' show ClaudeApiException, ClaudeApiService;
import '../domain/models/diary_entry.dart';
import '../domain/repositories/ai_feedback_repository.dart';

/// Implements [AiFeedbackRepository] using Isar cache and [ClaudeApiService].
class AiFeedbackRepositoryImpl implements AiFeedbackRepository {
  AiFeedbackRepositoryImpl({
    required Isar isar,
    required ClaudeApiService apiService,
    required ApiKeySecureStorage apiKeyStorage,
  })  : _isar = isar,
        _apiService = apiService,
        _apiKeyStorage = apiKeyStorage;

  final Isar _isar;
  final ClaudeApiService _apiService;
  final ApiKeySecureStorage _apiKeyStorage;

  @override
  Future<String?> getFeedback(int entryId, String language) async {
    final entry = await _isar.diaryEntrys.get(entryId);
    if (entry == null) return null;

    if (entry.aiFeedbackLoaded && entry.aiFeedback != null) {
      return entry.aiFeedback;
    }

    final apiKey = await _apiKeyStorage.getApiKey();
    if (apiKey == null || apiKey.isEmpty) return null;

    try {
      final feedback = await _apiService.getFeedback(
        apiKey: apiKey,
        diaryText: entry.text,
        language: language,
      );

      entry.aiFeedback = feedback;
      entry.aiFeedbackLoaded = true;
      await _isar.writeTxn(() => _isar.diaryEntrys.put(entry));

      return feedback;
    } on ClaudeApiException {
      rethrow;
    } catch (_) {
      return null;
    }
  }
}
