/// 7 日分のイベントサマリからプロンプトを構築。infrastructure 層内で完結。
///
/// 出力形式（JSON）:
/// - summaryText: string（要約文）
/// - detailsJson: string（オプション、JSON 配列の文字列。要素は { "title": string, "body": string }）
class PromptBuilder {
  static const String _systemPrompt = '''
あなたはユーザーの日々の体調・気分ログを分析するアシスタントです。
入力は直近7日分の指標ログ（日付・指標名・スコア）のテキストです。
以下の JSON 形式のみで回答してください。他の説明は不要です。

{
  "summaryText": "2〜3文程度の要約（日本語）",
  "detailsJson": "[{"title":"見出し","body":"説明"}, ...]"
}

detailsJson は JSON 配列を文字列化したもの。0件でも [] でよい。
''';

  static String buildSystemPrompt() => _systemPrompt;

  static String buildUserPrompt(String eventsSummary) {
    return '以下の直近のログを分析し、傾向とアドバイスを JSON で返してください。\n\n$eventsSummary';
  }
}
