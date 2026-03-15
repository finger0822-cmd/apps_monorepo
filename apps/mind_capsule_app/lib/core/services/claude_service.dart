import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

/// Claude Messages API を呼び出すサービス。
/// システムプロンプトとユーザーコンテンツを渡してテキストを取得する。
class ClaudeService {
  ClaudeService({http.Client? client}) : _client = client ?? http.Client();

  static const String _model = 'claude-haiku-4-5-20251001';
  static const int _maxTokens = 300;
  static const String _anthropicVersion = '2023-06-01';

  final http.Client _client;

  /// Claude API を呼び出し、応答テキストを返す。
  /// エラー時は [ClaudeServiceException] をスローする。
  Future<String> call({
    required String apiKey,
    required String systemPrompt,
    required String userContent,
  }) async {
    final body = {
      'model': _model,
      'max_tokens': _maxTokens,
      'system': systemPrompt,
      'messages': [
        {'role': 'user', 'content': userContent},
      ],
    };

    final response = await _client.post(
      Uri.parse(AppConstants.claudeApiBaseUrl),
      headers: {
        'x-api-key': apiKey,
        'anthropic-version': _anthropicVersion,
        'content-type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw ClaudeServiceException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['content'] as List<dynamic>?;
    if (content == null || content.isEmpty) {
      throw const ClaudeServiceException(
        statusCode: 200,
        body: 'Empty content in response',
      );
    }

    final firstBlock = content.first as Map<String, dynamic>;
    if (firstBlock['type'] != 'text') {
      throw ClaudeServiceException(
        statusCode: 200,
        body: 'Unexpected content type: ${firstBlock['type']}',
      );
    }

    final text = firstBlock['text'] as String?;
    if (text == null || text.isEmpty) {
      throw const ClaudeServiceException(
        statusCode: 200,
        body: 'Empty text in content block',
      );
    }

    return text.trim();
  }
}

/// Claude API 呼び出し時の例外
class ClaudeServiceException implements Exception {
  const ClaudeServiceException({required this.statusCode, required this.body});

  final int statusCode;
  final String body;

  @override
  String toString() => 'ClaudeServiceException($statusCode): $body';
}
