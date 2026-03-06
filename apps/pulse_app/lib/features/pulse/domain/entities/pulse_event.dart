/// Flat domain event for the Insights slice.
/// localDate is "YYYY-MM-DD".
class PulseEvent {
  const PulseEvent({
    required this.eventId,
    required this.userId,
    required this.occurredAtUtc,
    required this.localDate,
    required this.type,
    required this.payloadJson,
  });

  final String eventId;
  final String userId;
  final DateTime occurredAtUtc;
  final String localDate;
  final String type;
  final String payloadJson;
}
