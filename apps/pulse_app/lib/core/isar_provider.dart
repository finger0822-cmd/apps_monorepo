import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/isar/isar_pulse_event_entity.dart';
import '../data/isar/pulse_log_entity.dart';

/// Opens Isar with [PulseLogEntity] and [IsarPulseEventEntity] schemas in application documents directory.
/// Pass [extraSchemas] to include feature schemas (e.g. IsarInsightEntitySchema from features/pulse).
/// After opening, call IsarDb.setInstance(isar) if using the Insights slice.
Future<Isar> openIsar({
  List<CollectionSchema<dynamic>> extraSchemas = const [],
}) async {
  final dir = await getApplicationDocumentsDirectory();
  final schemas = [
    PulseLogEntitySchema,
    IsarPulseEventEntitySchema,
    ...extraSchemas,
  ];
  return Isar.open(schemas, directory: dir.path);
}
