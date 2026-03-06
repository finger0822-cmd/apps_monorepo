import 'package:isar/isar.dart';
import 'package:pulse_app/core/result.dart';
import 'package:pulse_app/data/isar/isar_pulse_event_entity.dart';
import 'package:pulse_app/features/pulse/domain/entities/pulse_event.dart';
import 'package:pulse_app/features/pulse/domain/repositories/pulse_event_repository.dart';
import 'package:pulse_app/features/pulse/infrastructure/datasources/isar/isar_db.dart';

/// Isar implementation of [PulseEventRepository] for the Insights slice.
/// Uses the existing IsarPulseEventEntity collection (see lib/data/isar).
/// Collection name: isarPulseEventEntitys (from generated .g.dart).
class IsarPulseEventRepository implements PulseEventRepository {
  IsarPulseEventRepository([Isar? isar]) : _isar = isar ?? IsarDb.getInstance();

  final Isar _isar;

  @override
  Future<Result<void>> save(PulseEvent event) async {
    try {
      final entity = _toEntity(event);
      await _isar.writeTxn(() async {
        await _isar.isarPulseEventEntitys.put(entity);
      });
      return const Ok(null);
    } catch (e, st) {
      return Err(StorageError('$e\n$st'));
    }
  }

  @override
  Future<Result<List<PulseEvent>>> listByLocalDateRange(
    String userId,
    String startLocalDateInclusive,
    String endLocalDateInclusive,
  ) async {
    try {
      final entities = await _isar.isarPulseEventEntitys
          .filter()
          .userIdEqualTo(userId)
          .localDateBetween(
            startLocalDateInclusive,
            endLocalDateInclusive,
            includeLower: true,
            includeUpper: true,
          )
          .findAll();
      final list = entities.map(_fromEntity).toList();
      return Ok(list);
    } catch (e, st) {
      return Err(StorageError('$e\n$st'));
    }
  }

  IsarPulseEventEntity _toEntity(PulseEvent e) {
    return IsarPulseEventEntity()
      ..eventId = e.eventId
      ..userId = e.userId
      ..occurredAtUtcIso = e.occurredAtUtc.toUtc().toIso8601String()
      ..localDate = e.localDate
      ..type = e.type
      ..payloadJson = e.payloadJson;
  }

  PulseEvent _fromEntity(IsarPulseEventEntity e) {
    return PulseEvent(
      eventId: e.eventId,
      userId: e.userId,
      occurredAtUtc: DateTime.parse(e.occurredAtUtcIso).toUtc(),
      localDate: e.localDate,
      type: e.type,
      payloadJson: e.payloadJson,
    );
  }
}
