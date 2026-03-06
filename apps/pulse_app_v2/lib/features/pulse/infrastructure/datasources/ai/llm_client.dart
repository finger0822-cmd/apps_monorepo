/// LLM 呼び出しの抽象。infrastructure 層。domain からは参照しない。
abstract interface class LlmClient {
  /// システムプロンプトとユーザープロンプトで完了を要求。戻りはプレーン文字列（JSON 想定）。
  Future<String> complete(String systemPrompt, String userPrompt);
}
