import 'package:isar/isar.dart';

part 'isar_pulse_event_entity.g.dart';

@collection
class IsarPulseEventEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String eventId;

  @Index()
  late String userId;

  late String occurredAtUtcIso;

  @Index()
  late String localDate;

  late String type;
  late String payloadJson;
}
