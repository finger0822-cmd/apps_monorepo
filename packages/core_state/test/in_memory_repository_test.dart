import 'package:core_state/core_state.dart';
import 'package:test/test.dart';

void main() {
  group('InMemoryStateRepository', () {
    test('upsert overwrites existing entry on the same day', () async {
      final repository = InMemoryStateRepository<DailyStateEntry>();
      final first = DailyStateEntry(
        id: 'a',
        date: DateTime(2026, 2, 10, 8, 0),
        createdAt: DateTime(2026, 2, 10, 8, 0),
        updatedAt: DateTime(2026, 2, 10, 8, 0),
        energy: 2,
        focus: 2,
        fatigue: 4,
      );
      final second = DailyStateEntry(
        id: 'b',
        date: DateTime(2026, 2, 10, 21, 0),
        createdAt: DateTime(2026, 2, 10, 21, 0),
        updatedAt: DateTime(2026, 2, 10, 21, 0),
        energy: 5,
        focus: 3,
        fatigue: 2,
      );

      await repository.upsert(first);
      await repository.upsert(second);

      expect((await repository.findByDate(DateTime(2026, 2, 10)))?.id, 'b');
      expect((await repository.latest(10)).length, 1);
      expect((await repository.latest(1)).first.energy.value, 5);
    });

    test('findRange/latest/deleteById work as expected', () async {
      final repository = InMemoryStateRepository<DailyStateEntry>();
      await repository.upsert(
        DailyStateEntry(
          id: 'd1',
          date: DateTime(2026, 2, 1),
          createdAt: DateTime(2026, 2, 1, 10, 0),
          updatedAt: DateTime(2026, 2, 1, 10, 0),
          energy: 3,
          focus: 3,
          fatigue: 3,
        ),
      );
      await repository.upsert(
        DailyStateEntry(
          id: 'd2',
          date: DateTime(2026, 2, 3),
          createdAt: DateTime(2026, 2, 3, 10, 0),
          updatedAt: DateTime(2026, 2, 3, 10, 0),
          energy: 4,
          focus: 4,
          fatigue: 2,
        ),
      );

      final range = await repository.findRange(
        DateTime(2026, 2, 1, 20, 0),
        DateTime(2026, 2, 3, 1, 0),
      );
      expect(range.map((e) => e.id).toList(), <String>['d1', 'd2']);

      final latest = await repository.latest(1);
      expect(latest.single.id, 'd2');

      expect(await repository.deleteById('d2'), isTrue);
      expect(await repository.findByDate(DateTime(2026, 2, 3)), isNull);
    });
  });
}
