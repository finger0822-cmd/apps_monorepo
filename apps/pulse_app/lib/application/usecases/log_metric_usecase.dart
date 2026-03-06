import '../../domain/pulse_domain.dart';

/// 1件の指標ログを組み立て、保存し、Observation と MetricLogged イベントを返す。
/// [eventRepo] が null の場合は保存をスキップ（暫定雛形）。
class LogMetricUseCase {
  LogMetricUseCase({this.eventRepo});

  final PulseEventRepository? eventRepo;

  Future<LogMetricResult> execute({
    required String userId,
    required PulseMetric metric,
    required int score,
    String? note,
  }) async {
    final score100 = Score100(score);
    final nowUtc = DateTime.now().toUtc();
    final observedAt = ObservedAt.fromUtc(nowUtc);
    final observationId = 'obs_${nowUtc.microsecondsSinceEpoch}';

    final observation = PulseObservation(
      id: observationId,
      metric: metric,
      score: score100,
      observedAt: observedAt,
      note: note,
    );

    final event = MetricLogged(
      userId: userId,
      occurredAtUtc: nowUtc,
      observation: observation,
    );

    if (eventRepo != null) {
      await eventRepo!.saveEvent(event);
    }

    return LogMetricResult(observation: observation, event: event);
  }
}

class LogMetricResult {
  const LogMetricResult({
    required this.observation,
    required this.event,
  });

  final PulseObservation observation;
  final MetricLogged event;
}
