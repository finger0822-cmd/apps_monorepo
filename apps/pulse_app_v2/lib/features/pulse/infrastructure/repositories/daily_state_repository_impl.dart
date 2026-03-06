import 'package:core_state/core_state.dart';
import 'package:pulse_app/features/pulse/domain/entities/daily_state.dart';
import 'package:pulse_app/features/pulse/domain/repositories/daily_state_repository.dart';
import 'package:pulse_app/features/pulse/infrastructure/mappers/daily_state_mapper.dart';

/// [DailyStateRepository] の実装。core_state の [StateRepository] に委譲。
class DailyStateRepositoryImpl implements DailyStateRepository {
  DailyStateRepositoryImpl(this._stateRepo);

  final StateRepository<DailyStateEntry> _stateRepo;

  @override
  Future<DailyState> upsert(DailyState entry) async {
    final coreEntry = DailyStateMapper.toEntry(entry);
    final result = await _stateRepo.upsert(coreEntry);
    return DailyStateMapper.fromEntry(result);
  }

  @override
  Future<DailyState?> findByDate(DateTime date) async {
    final entry = await _stateRepo.findByDate(date);
    return entry != null ? DailyStateMapper.fromEntry(entry) : null;
  }

  @override
  Future<List<DailyState>> findRange(DateTime from, DateTime to) async {
    final list = await _stateRepo.findRange(from, to);
    return list.map(DailyStateMapper.fromEntry).toList();
  }

  @override
  Future<List<DailyState>> latest(int count) async {
    final list = await _stateRepo.latest(count);
    return list.map(DailyStateMapper.fromEntry).toList();
  }

  @override
  Future<bool> deleteById(String id) async {
    return _stateRepo.deleteById(id);
  }
}
