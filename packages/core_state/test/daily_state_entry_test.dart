import 'package:core_state/core_state.dart';
import 'package:test/test.dart';

void main() {
  group('DailyStateEntry', () {
    test('throws ArgumentError when rating is out of range', () {
      expect(
        () => DailyStateEntry(
          id: 'x1',
          date: DateTime(2026, 2, 1),
          createdAt: DateTime(2026, 2, 1, 9, 0),
          updatedAt: DateTime(2026, 2, 1, 9, 0),
          energy: 0,
          focus: 3,
          fatigue: 3,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('normalizes date to day', () {
      final entry = DailyStateEntry(
        id: 'x2',
        date: DateTime(2026, 2, 1, 23, 59, 59),
        createdAt: DateTime(2026, 2, 1, 9, 0),
        updatedAt: DateTime(2026, 2, 1, 10, 0),
        energy: 4,
        focus: 4,
        fatigue: 2,
      );

      expect(entry.date, DateTime(2026, 2, 1));
      expect(toDateKey(entry.date), '2026-02-01');
    });
  });
}
