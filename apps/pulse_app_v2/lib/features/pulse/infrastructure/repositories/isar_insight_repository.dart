import 'package:isar/isar.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/isar/isar_insight_entity.dart';

/// Isar へのインサイト保存・取得。AiInsightRepository から利用する。
class IsarInsightRepository {
  IsarInsightRepository(this._isar);

  final Isar _isar;

  static String _localDateToString(LocalDate d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  static LocalDate _localDateFromString(String s) {
    final parts = s.split('-');
    if (parts.length != 3) {
      throw FormatException('LocalDate format YYYY-MM-DD: $s');
    }
    return LocalDate(
      year: int.parse(parts[0]),
      month: int.parse(parts[1]),
      day: int.parse(parts[2]),
    );
  }

  Future<void> save(Insight insight) async {
    final entity = _toEntity(insight);
    await _isar.writeTxn(() async {
      await _isar.isarInsightEntitys.put(entity);
    });
  }

  Future<List<Insight>> list(LocalDate start, LocalDate end) async {
    final startStr = _localDateToString(start);
    final endStr = _localDateToString(end);
    final entities = await _isar.isarInsightEntitys
        .where()
        .anyId()
        .filter()
        .scopeStartEqualTo(startStr)
        .scopeEndEqualTo(endStr)
        .sortByGeneratedAtUtcIsoDesc()
        .findAll();
    return entities.map(_toDomain).toList();
  }

  static Insight _toDomain(IsarInsightEntity entity) {
    return Insight(
      id: entity.insightId,
      createdAt: DateTime.parse(entity.generatedAtUtcIso).toUtc(),
      scopeLocalDateStart: _localDateFromString(entity.scopeStart),
      scopeLocalDateEnd: _localDateFromString(entity.scopeEnd),
      summaryText: entity.summaryText,
      bulletPoints: entity.detailsJson,
    );
  }

  static IsarInsightEntity _toEntity(Insight insight) {
    return IsarInsightEntity()
      ..insightId = insight.id
      ..generatedAtUtcIso = insight.createdAt.toUtc().toIso8601String()
      ..scopeStart = _localDateToString(insight.scopeLocalDateStart)
      ..scopeEnd = _localDateToString(insight.scopeLocalDateEnd)
      ..summaryText = insight.summaryText
      ..detailsJson = insight.bulletPoints;
  }
}
