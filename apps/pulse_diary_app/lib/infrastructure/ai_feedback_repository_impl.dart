import 'package:flutter/foundation.dart';
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

    // APIキー取得（シミュレータでは secure storage が動かない場合あり）
    String? apiKey;
    try {
      apiKey = await _apiKeyStorage.getApiKey();
    } catch (_) {
      apiKey = null;
    }
    if (apiKey == null || apiKey.isEmpty) return null;

    try {
      final userContent =
          '今日の状態:\n  気力: ${entry.energy}/5\n  集中: ${entry.focus}/5\n  疲れ: ${entry.fatigue}/5\n  気分: ${entry.mood}/5\n  眠気: ${entry.sleepiness}/5\n\n今日の日記:\n${entry.text}';
      final feedback = await _apiService.getFeedback(
        apiKey: apiKey,
        diaryText: userContent,
        language: language,
      );

      entry.aiFeedback = feedback;
      entry.aiFeedbackLoaded = true;
      await _isar.writeTxn(() => _isar.diaryEntrys.put(entry));

      return feedback;
    } on ClaudeApiException catch (e) {
      debugPrint('ClaudeApiException: $e');
      rethrow;
    } catch (e, st) {
      debugPrint('Unknown error: $e\n$st');
      return null;
    }
  }
}
