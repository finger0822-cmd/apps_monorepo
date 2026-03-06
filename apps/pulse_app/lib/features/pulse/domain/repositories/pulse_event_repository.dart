import 'package:pulse_app/core/result.dart';
import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';

abstract interface class PulseEventRepository {
  Future<Result<void>> save(PulseEvent event);
  Future<Result<List<PulseEvent>>> listByLocalDateRange(
    String userId,
    String startLocalDateInclusive,
    String endLocalDateInclusive,
  );
}
