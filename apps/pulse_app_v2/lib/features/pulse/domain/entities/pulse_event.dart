import 'package:pulse_app/features/pulse/domain/value_objects/observed_at.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/score.dart';

/// 暫定5指標。互換性のため String/ValueObject 化に置き換える可能性あり。
enum PulseMetric { motivation, focus, recovery, mood, alertness }

/// 1回の観測。id の生成は別層。Domain は生成方式に依存しない。
class PulseObservation {
  const PulseObservation({
    required this.id,
    required this.metric,
    required this.score,
    required this.observedAt,
    this.note,
  });

  final String id;
  final PulseMetric metric;
  final Score100 score;
  final ObservedAt observedAt;
  final String? note;
}

/// 記録の最小単位。Event Sourcing のイベント。
sealed class PulseEvent {
  const PulseEvent({required this.userId, required this.occurredAtUtc});

  final String userId;
  final DateTime occurredAtUtc;
}

/// 指標が1件ログされたときのイベント。
class MetricLogged extends PulseEvent {
  const MetricLogged({
    required super.userId,
    required super.occurredAtUtc,
    required this.observation,
  });

  final PulseObservation observation;
}

/// サブスクリプションが変更されたときのイベント。
class SubscriptionChanged extends PulseEvent {
  const SubscriptionChanged({
    required super.userId,
    required super.occurredAtUtc,
    required this.plan,
  });

  final SubscriptionPlan plan;
}

enum SubscriptionPlan { free, premium }
