import 'package:isar/isar.dart';

part 'pulse_log_entity.g.dart';

@collection
class PulseLogEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String entryId;

  @Index()
  late DateTime date;

  late DateTime createdAt;
  late DateTime updatedAt;
  late int energy;
  late int focus;
  late int fatigue;
  int? mood;
  int? sleepiness;
  String? note;
}
