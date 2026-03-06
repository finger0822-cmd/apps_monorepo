import 'package:core_state/core_state.dart';
import 'package:pulse_app/features/pulse/domain/entities/daily_state.dart';

/// core_state の [DailyStateEntry] と domain の [DailyState] の変換。
class DailyStateMapper {
  static const int _defaultMoodSleepiness = 3;

  static DailyState fromEntry(DailyStateEntry entry) {
    return DailyState(
      id: entry.id,
      date: entry.date,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
      energy: entry.energy.value,
      focus: entry.focus.value,
      fatigue: entry.fatigue.value,
      mood: entry.mood?.value ?? _defaultMoodSleepiness,
      sleepiness: entry.sleepiness?.value ?? _defaultMoodSleepiness,
      note: entry.note,
    );
  }

  static DailyStateEntry toEntry(DailyState state) {
    return DailyStateEntry(
      id: state.id,
      date: state.date,
      createdAt: state.createdAt,
      updatedAt: state.updatedAt,
      energy: state.energy,
      focus: state.focus,
      fatigue: state.fatigue,
      mood: state.mood,
      sleepiness: state.sleepiness,
      note: state.note,
    );
  }
}
