import 'package:pulse_app/features/pulse/domain/entities/daily_state.dart';

/// 日次状態の永続化リポジトリ（domain の interface）。
abstract interface class DailyStateRepository {
  Future<DailyState> upsert(DailyState entry);
  Future<DailyState?> findByDate(DateTime date);
  Future<List<DailyState>> findRange(DateTime from, DateTime to);
  Future<List<DailyState>> latest(int count);
  Future<bool> deleteById(String id);
}
