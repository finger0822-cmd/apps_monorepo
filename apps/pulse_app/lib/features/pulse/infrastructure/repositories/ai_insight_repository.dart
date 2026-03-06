import 'dart:convert';

import 'package:pulse_app/core/result.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';
import 'package:pulse_app/features/pulse/domain/repositories/insight_repository.dart';
import 'package:pulse_app/features/pulse/infrastructure/ai/llm_client.dart';
import 'package:pulse_app/features/pulse/infrastructure/ai/prompt_builder.dart';
import 'package:pulse_app/features/pulse/infrastructure/repositories/isar_insight_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Returns a short user-facing message for AI failures.
String _userFacingAiMessage(Object e, StackTrace? st) {
  if (e is FunctionException) {
    final status = e.status;
    if (status >= 500) {
      return 'サーバーエラーが発生しました。しばらくしてやり直してください。';
    }
    if (status == 400) {
      return 'リクエストに問題があります。';
    }
  }
  final msg = e.toString().toLowerCase();
  if (msg.contains('socket') || msg.contains('connection') || msg.contains('network')) {
    return '通信できませんでした。接続を確認してください。';
  }
  if (msg.contains('format') || msg.contains('parse') || msg.contains('json')) {
    return '回答の取得に失敗しました。';
  }
  return 'AI の処理中にエラーが発生しました。しばらくしてやり直してください。';
}

/// AI-backed implementation of [InsightRepository].
/// Calls LLM then persists via [IsarInsightStore].
class AiInsightRepository implements InsightRepository {
  AiInsightRepository({
    required LlmClient llmClient,
    IsarInsightStore? store,
  })  : _llm = llmClient,
        _store = store ?? IsarInsightStore();

  final LlmClient _llm;
  final IsarInsightStore _store;
  static const String _modelName = 'gpt-4.1-mini';

  @override
  Future<Result<Insight>> generateAndSave(
    String userId,
    String rangeKey,
    List<PulseEvent> events,
  ) async {
    if (events.isEmpty) {
      return Err(ValidationError('events must not be empty'));
    }
    try {
      final prompt = PromptBuilder.buildWeeklyInsightPrompt(userId, rangeKey, events);
      final response = await _llm.generate(_modelName, prompt);
      final map = jsonDecode(response.text) as Map<String, dynamic>;
      final summary = map['summary'] as String? ?? '';
      final bulletsList = map['bullets'];
      final bullets = bulletsList is List
          ? bulletsList.map((e) => e.toString()).toList()
          : <String>[];

      final insight = Insight(
        id: _uuidLike(),
        userId: userId,
        rangeKey: rangeKey,
        model: _modelName,
        promptVersion: PromptBuilder.promptVersion,
        createdAtUtc: DateTime.now().toUtc(),
        summaryText: summary,
        bullets: bullets,
      );
      await _store.save(insight);
      return Ok(insight);
    } catch (e, st) {
      return Err(AiError(_userFacingAiMessage(e, st)));
    }
  }

  @override
  Future<Result<List<Insight>>> listByRangeKey(String userId, String rangeKey) async {
    try {
      final list = await _store.listByRangeKey(userId, rangeKey);
      return Ok(list);
    } catch (e, st) {
      return Err(StorageError('$e\n$st'));
    }
  }

  static String _uuidLike() {
    return '${DateTime.now().toUtc().microsecondsSinceEpoch}';
  }
}
