import 'package:isar/isar.dart';

part 'isar_insight_entity.g.dart';

@collection
class IsarInsightEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String insightId;

  late String generatedAtUtcIso;
  late String scopeStart;
  late String scopeEnd;
  late String summaryText;
  String? detailsJson;
}
