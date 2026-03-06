import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';
import 'package:pulse_app/features/pulse/domain/repositories/insight_repository.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/ai/insight_response_parser.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/ai/llm_client.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/ai/prompt_builder.dart';
import 'package:pulse_app/features/pulse/infrastructure/repositories/isar_insight_repository.dart';

/// [InsightRepository] の AI 実装。LlmClient で生成し Isar に保存。差し替え可能。
class AiInsightRepository implements InsightRepository {
  AiInsightRepository({
    required LlmClient llmClient,
    required IsarInsightRepository isarStore,
  })  : _llmClient = llmClient,
        _isarStore = isarStore;

  final LlmClient _llmClient;
  final IsarInsightRepository _isarStore;

  static const String _promptVersion = '1';
  static const String _modelId = 'dummy';

  static String _localDateToString(LocalDate d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static String _eventsToSummaryText(List<PulseEvent> events) {
    final buffer = StringBuffer();
    final byDate = <String, List<PulseEvent>>{};
    for (final e in events) {
      final dateStr = _localDateToString(LocalDate.fromDateTime(e.occurredAtUtc));
      byDate.putIfAbsent(dateStr, () => []).add(e);
    }
    final sortedDates = byDate.keys.toList()..sort();
    for (final dateStr in sortedDates) {
      buffer.writeln('$dateStr:');
      for (final e in byDate[dateStr]!) {
        switch (e) {
          case MetricLogged(observation: final obs):
            buffer.writeln(
              '  ${obs.metric.name}=${obs.score.value}'
              '${obs.note != null ? ' (${obs.note})' : ''}',
            );
          case SubscriptionChanged(plan: final plan):
            buffer.writeln('  subscription=$plan');
        }
      }
    }
    return buffer.toString().trim().isEmpty ? '（ログなし）' : buffer.toString();
  }

  @override
  Future<Insight> generate(
    LocalDate start,
    LocalDate end,
    List<PulseEvent> events,
  ) async {
    final eventsSummary = _eventsToSummaryText(events);
    final systemPrompt = PromptBuilder.buildSystemPrompt();
    final userPrompt = PromptBuilder.buildUserPrompt(eventsSummary);
    final response = await _llmClient.complete(systemPrompt, userPrompt);

    final createdAt = DateTime.now().toUtc();
    final insightId =
        'insight_${start.year}-${start.month}-${start.day}_${createdAt.millisecondsSinceEpoch}';
    final insight = InsightResponseParser.parse(
      response,
      scopeStart: start,
      scopeEnd: end,
      createdAt: createdAt,
      id: insightId,
      model: _modelId,
      promptVersion: int.tryParse(_promptVersion),
    );
    if (insight == null) {
      throw Exception('AI の応答を解釈できませんでした。');
    }
    await _isarStore.save(insight);
    return insight;
  }

  @override
  Future<List<Insight>> list(LocalDate start, LocalDate end) async {
    return _isarStore.list(start, end);
  }
}
