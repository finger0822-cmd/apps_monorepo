import 'package:pulse_app/features/pulse/infrastructure/datasources/ai/llm_client.dart';

/// [LlmClient] の MVP 用ダミー実装。固定 JSON を遅延で返す。
/// 後で API Key と HTTP 呼び出しに差し替え。
class OpenAIClient implements LlmClient {
  @override
  Future<String> complete(String systemPrompt, String userPrompt) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return '''
{
  "summaryText": "直近の傾向として、気力・集中はやや安定しており、疲れが週後半にやや増えています。気分の波はありますが、全体的にバランスは取れています。",
  "detailsJson": "[{"title":"気力・集中","body":"比較的安定したスコアが続いています。"},{"title":"疲れ","body":"週後半にやや上昇傾向です。"}]"
}
''';
  }
}
