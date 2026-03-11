import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../../core/services/claude_service.dart';
import '../../core/storage/api_key_storage.dart';
import '../../domain/models/mind_entry.dart';
import '../../domain/repositories/entry_repository.dart';

// ── AI プロンプト定数（このファイル内に定義）────────────────────────────

/// 今日の記録を1〜3文で要約するためのシステムプロンプト
const String _systemPromptAiFeedback =
    'あなたはユーザーの日々の体調・気分ログと日記を分析するアシスタントです。'
    '今日の記録をもとに、共感を込めて1〜3文で要約してください。';

/// リポジトリの実装。Isar と ClaudeService・ApiKeyStorage で永続化・AI 分析を行う。
class EntryRepositoryImpl implements EntryRepository {
  EntryRepositoryImpl({
    required Isar isar,
    required ClaudeService claudeService,
    required ApiKeyStorage apiKeyStorage,
  })  : _isar = isar,
        _claudeService = claudeService,
        _apiKeyStorage = apiKeyStorage;

  final Isar _isar;
  final ClaudeService _claudeService;
  final ApiKeyStorage _apiKeyStorage;

  
  @override
  Future<void> save(MindEntry entry) async {
    await _isar.writeTxn(() async {
      await _isar.mindEntrys.put(entry);
    });
  }

  @override
  Future<void> update(MindEntry entry) async {
    await _isar.writeTxn(() async {
      await _isar.mindEntrys.put(entry);
    });
  }

  @override
  Future<bool> delete(int id) async {
    return await _isar.writeTxn(() async {
      return await _isar.mindEntrys.delete(id);
    });
  }

  @override
  Future<List<MindEntry>> getAll() async {
    return await _isar.mindEntrys.where().sortByCreatedAtDesc().findAll();
  }

  @override
  Future<MindEntry?> getById(int id) async {
    return await _isar.mindEntrys.get(id);
  }

  @override
  Future<List<MindEntry>> getRecent(int limit) async {
    return await _isar.mindEntrys
        .where()
        .sortByCreatedAtDesc()
        .limit(limit)
        .findAll();
  }

  @override
  Future<String?> fetchAiFeedback(int id, String language) async {
    final entry = await _isar.mindEntrys.get(id);
    if (entry == null) return null;

    if (entry.aiFeedbackLoaded && entry.aiFeedback != null) {
      return entry.aiFeedback;
    }

    final apiKey = await _apiKeyStorage.getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      return null;
    }

    final langInstruction =
        language == 'ja' ? '日本語で答えてください。' : 'Answer in English.';
    final userContent = '''
今日の状態:
  気力: ${entry.energy}/5
  集中: ${entry.focus}/5
  疲れ: ${entry.fatigue}/5
  気分: ${entry.mood}/5
  眠気: ${entry.sleepiness}/5

今日の日記:
${entry.text}

$langInstruction
''';

    try {
      final feedback = await _claudeService.call(
        apiKey: apiKey,
        systemPrompt: _systemPromptAiFeedback,
        userContent: userContent,
      );
      entry.aiFeedback = feedback;
      entry.aiFeedbackLoaded = true;
      await update(entry);
      return feedback;
    } on ClaudeServiceException catch (e) {
      debugPrint('fetchAiFeedback ClaudeServiceException: $e');
      return null;
    } catch (e, st) {
      debugPrint('fetchAiFeedback error: $e\n$st');
      return null;
    }
  }

  @override
  Future<String?> fetchAiPeriodAnalysis(List<int> entryIds, int days, String language) async {
    if (entryIds.isEmpty) return null;

    final apiKey = await _apiKeyStorage.getApiKey();
    if (apiKey == null || apiKey.isEmpty) return null;

    final entries = await Future.wait(entryIds.map((id) => _isar.mindEntrys.get(id)));
    final valid = entries.whereType<MindEntry>().toList();
    if (valid.isEmpty) return null;

    final langInstruction = language == 'ja' ? '日本語で答えてください。' : 'Answer in English.';
    final buffer = StringBuffer();
    final label = days == 0 ? '全期間' : '過去${days}日間';
    buffer.writeln('【$labelの記録】');
    for (final e in valid) {
      buffer.writeln(
          '日付: ${e.createdAt.toIso8601String().split('T').first} | 気力${e.energy} 集中${e.focus} 疲れ${e.fatigue} 気分${e.mood} 眠気${e.sleepiness}');
      buffer.writeln('日記: ${e.text}');
      buffer.writeln('---');
    }
    buffer.writeln(langInstruction);

    const systemPrompt =
        'あなたはユーザーの日々の体調・気分ログを分析するアシスタントです。'
        '指定期間の記録をもとに、傾向・特徴・アドバイスを3〜5文で分析してください。';

    try {
      return await _claudeService.call(
        apiKey: apiKey,
        systemPrompt: systemPrompt,
        userContent: buffer.toString(),
      );
    } catch (e) {
      debugPrint('fetchAiPeriodAnalysis error: $e');
      return null;
    }
  }
}
