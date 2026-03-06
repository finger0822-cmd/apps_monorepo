import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/isar/isar_db.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/isar/isar_insight_entity.dart';

/// Internal store for persisting and listing insights.
/// Collection name: isarInsightEntitys (from generated .g.dart).
class IsarInsightStore {
  IsarInsightStore([Isar? isar]) : _isar = isar ?? IsarDb.getInstance();

  final Isar _isar;

  Future<void> save(Insight insight) async {
    final entity = _toEntity(insight);
    await _isar.writeTxn(() async {
      await _isar.isarInsightEntitys.put(entity);
    });
  }

  Future<List<Insight>> listByRangeKey(String userId, String rangeKey) async {
    final entities = await _isar.isarInsightEntitys
        .filter()
        .userIdEqualTo(userId)
        .rangeKeyEqualTo(rangeKey)
        .sortByCreatedAtUtcIsoDesc()
        .findAll();
    return entities.map(_fromEntity).toList();
  }

  IsarInsightEntity _toEntity(Insight i) {
    return IsarInsightEntity()
      ..insightId = i.id
      ..userId = i.userId
      ..rangeKey = i.rangeKey
      ..model = i.model
      ..promptVersion = i.promptVersion
      ..createdAtUtcIso = i.createdAtUtc.toUtc().toIso8601String()
      ..summaryText = i.summaryText
      ..bulletsJson = jsonEncode(i.bullets);
  }

  Insight _fromEntity(IsarInsightEntity e) {
    final bullets = (jsonDecode(e.bulletsJson) as List<dynamic>)
        .map((x) => x.toString())
        .toList();
    return Insight(
      id: e.insightId,
      userId: e.userId,
      rangeKey: e.rangeKey,
      model: e.model,
      promptVersion: e.promptVersion,
      createdAtUtc: DateTime.parse(e.createdAtUtcIso).toUtc(),
      summaryText: e.summaryText,
      bullets: bullets,
    );
  }
}
