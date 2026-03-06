/// 暫定ドメイン骨格。
/// 将来 value_objects / model / events / subscription などにファイル分割する想定。

// =============================================================================
// 1. Value Objects（最小構成）
// =============================================================================

/// 0〜100 の整数スコア。範囲外は例外。
class Score100 {
  const Score100._(this.value);

  static bool _inRange(int v) => v >= 0 && v <= 100;

  final int value;

  factory Score100(int value) {
    if (!_inRange(value)) {
      throw ArgumentError('Score100 は 0〜100 である必要があります: $value');
    }
    return Score100._(value);
  }
}

/// 年月日。日付集計はこれを使用。DateTime の日付部分のみ利用する想定。
class LocalDate {
  const LocalDate({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;

  /// DateTime から日付部分のみを取り出して生成。
  factory LocalDate.fromDateTime(DateTime dt) {
    final utc = dt.toUtc();
    return LocalDate(year: utc.year, month: utc.month, day: utc.day);
  }
}

/// 観測日時。deviceTime は UTC 保持（toUtc 前提）。日付集計は [localDate] を使用。
class ObservedAt {
  const ObservedAt({
    required this.localDate,
    required this.deviceTime,
  });

  final LocalDate localDate;
  /// UTC で保持する想定。渡す前に [DateTime.toUtc] すること。
  final DateTime deviceTime;

  factory ObservedAt.fromUtc(DateTime utc) {
    return ObservedAt(
      localDate: LocalDate.fromDateTime(utc),
      deviceTime: utc.toUtc(),
    );
  }
}

// =============================================================================
// 2. Domain Model
// =============================================================================

/// 暫定5指標。将来の指標増減を想定。
/// 互換性のため、String キーや ValueObject 化に置き換える可能性あり。
enum PulseMetric {
  motivation,
  focus,
  recovery,
  mood,
  alertness,
}

/// 1回の観測。id の生成は別層（将来 UUID 想定）。Domain は生成方式に依存しない。
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

// =============================================================================
// 3. Domain Events（最小セット）
// 将来 AI 関連イベント（例: InsightGenerated）を追加予定。
// =============================================================================

sealed class PulseEvent {
  const PulseEvent({
    required this.userId,
    required this.occurredAtUtc,
  });

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

// =============================================================================
// 4. Subscription 概念
// =============================================================================

enum SubscriptionPlan {
  free,
  premium,
}

// =============================================================================
// 5. Repository Interface（将来 repository.dart などに分割予定）
// 拡張: ページング / 期間検索 / イベント種別フィルタなど。
// =============================================================================

abstract interface class PulseEventRepository {
  Future<void> saveEvent(PulseEvent event);
  Future<List<PulseEvent>> listEvents({
    required String userId,
    LocalDate? date,
  });
}

// =============================================================================
// 6. 拡張ポイント
// =============================================================================
// - 指標追加: [PulseMetric] に enum 値を追加、または String/ValueObject 化。
// - AI イベント追加: [PulseEvent] の sealed サブクラスとして追加。
// - ファイル分割: 上記セクションごとに value_objects.dart / model.dart / events.dart / subscription.dart / repository などへ分離予定。
