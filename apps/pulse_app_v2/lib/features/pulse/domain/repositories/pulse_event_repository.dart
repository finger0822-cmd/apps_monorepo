import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

abstract class PulseEventRepository {
  Future<void> saveEvent(PulseEvent event);
  Future<List<PulseEvent>> listEvents({
    required String userId,
    LocalDate? date,
  });
}
