import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../data/isar/pulse_log_entity.dart';

/// Opens Isar with [PulseLogEntity] schema in application documents directory.
Future<Isar> openIsar() async {
  late final Directory dir;
  try {
    dir = await getApplicationDocumentsDirectory();
  } catch (e) {
    // Fallback for environments where path_provider doesn't work
    final home = Platform.environment['HOME'] ?? '/tmp';
    dir = Directory('$home/.pulse_app');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }
  return Isar.open(
    [PulseLogEntitySchema],
    directory: dir.path,
  );
}
