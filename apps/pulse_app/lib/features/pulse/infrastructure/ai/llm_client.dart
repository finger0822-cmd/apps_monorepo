/// Abstract LLM client for insight generation.
abstract interface class LlmClient {
  Future<LlmResponse> generate(String model, String prompt);
}

class LlmResponse {
  const LlmResponse({required this.text});
  final String text;
}
