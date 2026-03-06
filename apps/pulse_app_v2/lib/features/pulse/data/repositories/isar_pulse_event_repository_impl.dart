import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:pulse_app/features/pulse/data/models/isar_pulse_event_entity.dart';
import 'package:pulse_app/features/pulse/domain/pulse_domain.dart';

/// [PulseEventRepository] の Isar 実装。
/// Isar.open() に [IsarPulseEventEntitySchema] を登録すること。
class IsarPulseEventRepository implements PulseEventRepository {
  IsarPulseEventRepository(this._isar);

  final Isar _isar;

  static final _metricByName = {for (final e in PulseMetric.values) e.name: e};
  static final _planByName = {
    for (final e in SubscriptionPlan.values) e.name: e,
  };

  static String _localDateToString(LocalDate d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static LocalDate _localDateFromString(String s) {
    final parts = s.split('-');
    if (parts.length != 3)
      throw FormatException('LocalDate format YYYY-MM-DD: $s');
    return LocalDate(
      year: int.parse(parts[0]),
      month: int.parse(parts[1]),
      day: int.parse(parts[2]),
    );
  }

  @override
  Future<void> saveEvent(PulseEvent event) async {
    final entity = _toEntity(event);
    await _isar.writeTxn(() async {
      await _isar.isarPulseEventEntitys.put(entity);
    });
  }

  IsarPulseEventEntity _toEntity(PulseEvent event) {
    final occurredAtUtc = event.occurredAtUtc;
    final occurredAtIso = occurredAtUtc.toUtc().toIso8601String();
    final localDateStr = _localDateToString(
      LocalDate.fromDateTime(occurredAtUtc),
    );

    switch (event) {
      case MetricLogged e:
        final obs = e.observation;
        final payload = {
          'observation': {
            'id': obs.id,
            'metric': obs.metric.name,
            'score': obs.score.value,
            'observedAt': {
              'localDate': _localDateToString(obs.observedAt.localDate),
              'deviceTimeIso': obs.observedAt.deviceTime
                  .toUtc()
                  .toIso8601String(),
            },
            'note': obs.note,
          },
        };
        return IsarPulseEventEntity()
          ..eventId = obs.id
          ..userId = e.userId
          ..occurredAtUtcIso = occurredAtIso
          ..localDate = localDateStr
          ..type = 'MetricLogged'
          ..payloadJson = jsonEncode(payload);

      case SubscriptionChanged e:
        final payload = {'plan': e.plan.name};
        return IsarPulseEventEntity()
          ..eventId = 'sub_${occurredAtUtc.millisecondsSinceEpoch}'
          ..userId = e.userId
          ..occurredAtUtcIso = occurredAtIso
          ..localDate = localDateStr
          ..type = 'SubscriptionChanged'
          ..payloadJson = jsonEncode(payload);
    }
  }

  @override
  Future<List<PulseEvent>> listEvents({
    required String userId,
    LocalDate? date,
  }) async {
    // 将来: ページング / 期間検索を追加予定。
    final q = _isar.isarPulseEventEntitys.filter().userIdEqualTo(userId);
    final entities = date != null
        ? await q.localDateEqualTo(_localDateToString(date)).findAll()
        : await q.findAll();
    final events = <PulseEvent>[];
    for (final entity in entities) {
      final event = _fromEntity(entity);
      if (event != null) events.add(event);
    }
    return events;
  }

  PulseEvent? _fromEntity(IsarPulseEventEntity entity) {
    final type = entity.type;
    if (type == 'MetricLogged') {
      return _parseMetricLogged(entity);
    }
    if (type == 'SubscriptionChanged') {
      return _parseSubscriptionChanged(entity);
    }
    return null;
  }

  MetricLogged? _parseMetricLogged(IsarPulseEventEntity entity) {
    try {
      final map = jsonDecode(entity.payloadJson) as Map<String, dynamic>;
      final obsMap = map['observation'] as Map<String, dynamic>?;
      if (obsMap == null) return null;
      final observedAtMap = obsMap['observedAt'] as Map<String, dynamic>?;
      if (observedAtMap == null) return null;
      final localDateStr = observedAtMap['localDate'] as String?;
      final deviceTimeIso = observedAtMap['deviceTimeIso'] as String?;
      if (localDateStr == null || deviceTimeIso == null) return null;
      final localDate = _localDateFromString(localDateStr);
      final deviceTime = DateTime.parse(deviceTimeIso).toUtc();
      final observedAt = ObservedAt(
        localDate: localDate,
        deviceTime: deviceTime,
      );
      final metricStr = obsMap['metric'] as String?;
      if (metricStr == null) return null;
      final metric = _metricByName[metricStr];
      if (metric == null) return null;
      final scoreVal = obsMap['score'] as int?;
      if (scoreVal == null) return null;
      final score = Score100(scoreVal);
      final observation = PulseObservation(
        id: obsMap['id'] as String? ?? '',
        metric: metric,
        score: score,
        observedAt: observedAt,
        note: obsMap['note'] as String?,
      );
      final occurredAtUtc = DateTime.parse(entity.occurredAtUtcIso).toUtc();
      return MetricLogged(
        userId: entity.userId,
        occurredAtUtc: occurredAtUtc,
        observation: observation,
      );
    } catch (_) {
      return null;
    }
  }

  SubscriptionChanged? _parseSubscriptionChanged(IsarPulseEventEntity entity) {
    try {
      final map = jsonDecode(entity.payloadJson) as Map<String, dynamic>;
      final planStr = map['plan'] as String?;
      if (planStr == null) return null;
      final plan = _planByName[planStr];
      if (plan == null) return null;
      final occurredAtUtc = DateTime.parse(entity.occurredAtUtcIso).toUtc();
      return SubscriptionChanged(
        userId: entity.userId,
        occurredAtUtc: occurredAtUtc,
        plan: plan,
      );
    } catch (_) {
      return null;
    }
  }
}
