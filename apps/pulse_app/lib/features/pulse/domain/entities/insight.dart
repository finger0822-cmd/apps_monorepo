/// AI-generated insight for a range (e.g. weekly).
class Insight {
  const Insight({
    required this.id,
    required this.userId,
    required this.rangeKey,
    required this.model,
    required this.promptVersion,
    required this.createdAtUtc,
    required this.summaryText,
    required this.bullets,
  });

  final String id;
  final String userId;
  final String rangeKey;
  final String model;
  final int promptVersion;
  final DateTime createdAtUtc;
  final String summaryText;
  final List<String> bullets;
}
