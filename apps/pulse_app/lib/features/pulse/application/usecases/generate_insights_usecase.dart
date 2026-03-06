import 'package:pulse_app/core/result.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';
import 'package:pulse_app/features/pulse/domain/repositories/insight_repository.dart';
import 'package:pulse_app/features/pulse/domain/repositories/pulse_event_repository.dart';

/// Fetches events in range then generates and saves an insight.
class GenerateInsightsUsecase {
  GenerateInsightsUsecase({
    required PulseEventRepository eventRepo,
    required InsightRepository insightRepo,
  })  : _eventRepo = eventRepo,
        _insightRepo = insightRepo;

  final PulseEventRepository _eventRepo;
  final InsightRepository _insightRepo;

  Future<Result<Insight>> execute({
    required String userId,
    required String rangeKey,
    required String startLocalDateInclusive,
    required String endLocalDateInclusive,
  }) async {
    final eventsResult = await _eventRepo.listByLocalDateRange(
      userId,
      startLocalDateInclusive,
      endLocalDateInclusive,
    );
    if (eventsResult is Err<List<PulseEvent>>) {
      return Err(eventsResult.error);
    }
    final events = (eventsResult as Ok<List<PulseEvent>>).value;
    return _insightRepo.generateAndSave(userId, rangeKey, events);
  }
}
