import 'dart:convert';

import 'package:http/http.dart' as http;

/// External API: Anthropic Claude Messages API only.
/// https://docs.anthropic.com/en/api/messages
class ClaudeApiService {
  ClaudeApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-haiku-4-5-20251001';
  static const int _maxTokens = 150;
  static const String _anthropicVersion = '2023-06-01';

  final http.Client _client;

  /// Calls Claude Messages API. [apiKey] must be provided by caller.
  Future<String> getFeedback({
    required String apiKey,
    required String diaryText,
    required String language,
  }) async {
    final languageInstruction = language == 'ja'
        ? 'Answer in Japanese. 日本語で答えてください。'
        : 'Answer in English.';

    const systemPrompt =
        'You give brief, encouraging feedback on diary entries in 1-2 sentences. Keep the response under 150 tokens.';

    final body = {
      'model': _model,
      'max_tokens': _maxTokens,
      'system': systemPrompt,
      'messages': [
        {
          'role': 'user',
          'content': '$diaryText\n\n$languageInstruction',
        },
      ],
    };

    final response = await _client.post(
      Uri.parse(_baseUrl),
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': _anthropicVersion,
        'content-type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw ClaudeApiException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>?;
    if (content == null || content.isEmpty) {
      throw const ClaudeApiException(
        statusCode: 200,
        body: 'Empty content in response',
      );
    }

    final firstBlock = content.first as Map<String, dynamic>;
    if (firstBlock['type'] != 'text') {
      throw ClaudeApiException(
        statusCode: 200,
        body: 'Unexpected content type: ${firstBlock['type']}',
      );
    }

    final text = firstBlock['text'] as String?;
    if (text == null || text.isEmpty) {
      throw const ClaudeApiException(
        statusCode: 200,
        body: 'Empty text in content block',
      );
    }

    return text.trim();
  }
}

class ClaudeApiException implements Exception {
  const ClaudeApiException({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final String body;

  @override
  String toString() => 'ClaudeApiException($statusCode): $body';
}
