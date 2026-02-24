import 'package:core_state/core_state.dart';
import 'package:test/test.dart';

void main() {
  group('StateStatsService', () {
    test('computes stats even with sparse data', () {
      final entries = <DailyStateEntry>[
        DailyStateEntry(
          id: 's1',
          date: DateTime(2026, 2, 1),
          createdAt: DateTime(2026, 2, 1, 8, 0),
          updatedAt: DateTime(2026, 2, 1, 8, 0),
          energy: 2,
          focus: 3,
          fatigue: 4,
        ),
        DailyStateEntry(
          id: 's2',
          date: DateTime(2026, 2, 4),
          createdAt: DateTime(2026, 2, 4, 8, 0),
          updatedAt: DateTime(2026, 2, 4, 8, 0),
          energy: 4,
          focus: 4,
          fatigue: 2,
        ),
      ];

      final stats = StateStatsService().computeStats(
        entries,
        periodStart: DateTime(2026, 2, 1),
        periodEnd: DateTime(2026, 2, 4),
      );

      expect(stats.daysCount, 2);
      expect(stats.missingDaysCount, 2);
      expect(stats.avgEnergy, closeTo(3.0, 0.0001));
      expect(stats.rangeEnergy, 2);
      expect(stats.trendEnergy, closeTo(2.0, 0.0001));
    });

    test('returns empty stats for empty input without crashing', () {
      final stats = StateStatsService().computeStats(
        const <DailyStateEntry>[],
        periodStart: DateTime(2026, 2, 1),
        periodEnd: DateTime(2026, 2, 7),
      );

      expect(stats.daysCount, 0);
      expect(stats.missingDaysCount, 7);
      expect(stats.avgFocus, 0);
      expect(stats.trendFatigue, 0);
    });
  });
}
