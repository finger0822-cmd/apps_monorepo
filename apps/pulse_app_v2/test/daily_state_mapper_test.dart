import 'package:core_state/core_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_app/features/pulse/infrastructure/mappers/daily_state_mapper.dart';
import 'package:pulse_app/features/pulse/domain/entities/daily_state.dart';

void main() {
  group('DailyStateMapper', () {
    test(
      'fromEntry fills default mood and sleepiness when null (legacy 3-field data)',
      () {
        final entry = DailyStateEntry(
          id: 'daily_2026-03-01',
          date: DateTime(2026, 3, 1),
          createdAt: DateTime(2026, 3, 1, 9, 0),
          updatedAt: DateTime(2026, 3, 1, 9, 0),
          energy: 2,
          focus: 3,
          fatigue: 4,
          // mood and sleepiness omitted -> null
        );

        final state = DailyStateMapper.fromEntry(entry);

        expect(state.energy, 2);
        expect(state.focus, 3);
        expect(state.fatigue, 4);
        expect(state.mood, 3);
        expect(state.sleepiness, 3);
      },
    );

    test('toEntry then fromEntry preserves all 5 metrics', () {
      final state = DailyState(
        id: 'daily_2026-03-02',
        date: DateTime(2026, 3, 2),
        createdAt: DateTime(2026, 3, 2, 10, 0),
        updatedAt: DateTime(2026, 3, 2, 10, 0),
        energy: 1,
        focus: 2,
        fatigue: 3,
        mood: 4,
        sleepiness: 5,
        note: null,
      );

      final entry = DailyStateMapper.toEntry(state);
      final roundTrip = DailyStateMapper.fromEntry(entry);

      expect(roundTrip.energy, state.energy);
      expect(roundTrip.focus, state.focus);
      expect(roundTrip.fatigue, state.fatigue);
      expect(roundTrip.mood, state.mood);
      expect(roundTrip.sleepiness, state.sleepiness);
    });
  });
}
