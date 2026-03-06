import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_app/features/pulse/domain/entities/daily_state.dart';
import 'package:pulse_app/features/pulse/domain/repositories/daily_state_repository.dart';
import 'package:pulse_app/features/pulse/domain/usecases/daily_state_upsert_usecase.dart';

void main() {
  group('DailyStateUpsertUsecase', () {
    test('upsertForDate passes 5 metrics to repository on new date', () async {
      DailyState? captured;
      final repo = _CaptureRepository((s) {
        captured = s;
        return Future.value(s);
      });

      final usecase = DailyStateUpsertUsecase(repo);
      final base = DateTime(2026, 3, 4, 12, 0);

      await usecase.upsertForDate(
        date: base,
        energy: 1,
        focus: 2,
        fatigue: 3,
        mood: 4,
        sleepiness: 5,
      );

      expect(captured, isNotNull);
      expect(captured!.energy, 1);
      expect(captured!.focus, 2);
      expect(captured!.fatigue, 3);
      expect(captured!.mood, 4);
      expect(captured!.sleepiness, 5);
    });
  });
}

class _CaptureRepository implements DailyStateRepository {
  _CaptureRepository(this._onUpsert);

  final Future<DailyState> Function(DailyState) _onUpsert;

  @override
  Future<DailyState> upsert(DailyState entry) => _onUpsert(entry);

  @override
  Future<DailyState?> findByDate(DateTime date) async => null;

  @override
  Future<List<DailyState>> findRange(DateTime from, DateTime to) async => [];

  @override
  Future<List<DailyState>> latest(int count) async => [];

  @override
  Future<bool> deleteById(String id) async => false;
}
