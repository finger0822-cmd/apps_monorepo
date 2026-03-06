import 'dart:convert';

import 'package:pulse_app/features/pulse/infrastructure/ai/llm_client.dart';

/// Development/test-only dummy. Do not use in production.
/// Production should use [SupabaseEdgeLlmClient] (Supabase Edge Function).
class DummyOpenAiClient implements LlmClient {
  @override
  Future<LlmResponse> generate(String model, String prompt) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final body = jsonEncode({
      'summary': '今週は記録が続いています。無理のないペースで観測を続けましょう。',
      'bullets': [
        '記録日数: サンプル週',
        '傾向: 安定',
        '提案: このまま継続を',
      ],
    });
    return LlmResponse(text: body);
  }
}
