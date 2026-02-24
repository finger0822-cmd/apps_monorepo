# core_state

`core_state` is a pure Dart package for reusable state logging across apps.

## Features

- Extensible state entry model (`StateEntry`)
- Daily state implementation (`DailyStateEntry`)
- In-memory repository for tests and local execution
- Statistical aggregation service (`StateStatsService`)
- AI summary input material builder (no AI API call)

## Package Structure

- `lib/src/model`: entries and value objects
- `lib/src/repository`: repository abstraction and in-memory implementation
- `lib/src/service`: stats DTO and stats service
- `lib/src/ai`: summary templates and prompt payload builder
- `lib/src/util`: date helpers and validators

## Example

```dart
import 'package:core_state/core_state.dart';

Future<void> main() async {
  final repo = InMemoryStateRepository<DailyStateEntry>();
  await repo.upsert(
    DailyStateEntry(
      id: '1',
      date: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      energy: 4,
      focus: 3,
      fatigue: 2,
      note: 'Steady day',
    ),
  );

  final stats = StateStatsService().computeStats(await repo.latest(7));
  final prompt = SummaryPromptBuilder().build(stats: stats);

  print(prompt.instructionText);
  print(prompt.jsonPayload);
}
```
