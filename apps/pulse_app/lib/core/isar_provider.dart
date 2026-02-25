import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/isar/pulse_log_entity.dart';

/// Opens Isar with [PulseLogEntity] schema in application documents directory.
Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [PulseLogEntitySchema],
    directory: dir.path,
  );
}
