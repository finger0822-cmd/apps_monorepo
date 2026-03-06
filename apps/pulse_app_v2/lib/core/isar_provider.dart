import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/isar/isar_insight_entity.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/isar/isar_pulse_event_entity.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/isar/pulse_log_entity.dart';

/// Opens Isar with [PulseLogEntity], [IsarPulseEventEntity], and [IsarInsightEntity] schemas in application documents directory.
Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open([
    PulseLogEntitySchema,
    IsarPulseEventEntitySchema,
    IsarInsightEntitySchema,
  ], directory: dir.path);
}
