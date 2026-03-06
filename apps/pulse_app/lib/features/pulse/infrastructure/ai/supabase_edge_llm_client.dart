import 'package:pulse_app/features/pulse/infrastructure/ai/llm_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Production LLM client. Calls Supabase Edge Function; API key stays on the server.
class SupabaseEdgeLlmClient implements LlmClient {
  SupabaseEdgeLlmClient({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  static const String _functionName = 'generate-pulse-insight';

  @override
  Future<LlmResponse> generate(String model, String prompt) async {
    final res = await _client.functions.invoke(
      _functionName,
      body: {'model': model, 'prompt': prompt},
    );

    if (res.data == null) {
      final msg = res.status >= 400
          ? 'Request failed (${res.status})'
          : 'Response body is empty';
      throw Exception(msg);
    }

    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected response type');
    }

    final text = data['text'];
    if (text == null || text is! String || text.isEmpty) {
      throw Exception('Response missing or invalid "text" field');
    }

    return LlmResponse(text: text);
  }
}
