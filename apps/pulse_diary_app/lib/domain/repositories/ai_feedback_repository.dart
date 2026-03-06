/// Repository interface for AI feedback. Implementation lives in infrastructure.
abstract class AiFeedbackRepository {
  /// Returns cached or newly fetched feedback for the entry.
  /// Returns null if entry not found, API key missing, or on error.
  /// May throw on API errors.
  Future<String?> getFeedback(int entryId, String language);
}
