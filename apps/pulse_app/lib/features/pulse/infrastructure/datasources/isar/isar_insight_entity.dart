import 'package:isar/isar.dart';

part 'isar_insight_entity.g.dart';

@collection
class IsarInsightEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String insightId;

  @Index()
  late String userId;

  @Index()
  late String rangeKey;

  late String model;
  late int promptVersion;
  late String createdAtUtcIso;
  late String summaryText;
  late String bulletsJson;
}
