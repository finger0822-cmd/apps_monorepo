import 'package:pulse_app/core/result.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';

abstract interface class InsightRepository {
  Future<Result<Insight>> generateAndSave(
    String userId,
    String rangeKey,
    List<PulseEvent> events,
  );
  Future<Result<List<Insight>>> listByRangeKey(String userId, String rangeKey);
}
