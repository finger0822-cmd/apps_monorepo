import '../util/date_normalizer.dart';
import '../util/validators.dart';
import 'state_entry.dart';
import 'value_objects.dart';

class DailyStateEntry extends StateEntry {
  final Rating energy;
  final Rating focus;
  final Rating fatigue;
  final Rating? mood;
  final Rating? sleepiness;
  final String? note;

  DailyStateEntry({
    required super.id,
    required DateTime date,
    required super.createdAt,
    required super.updatedAt,
    required int energy,
    required int focus,
    required int fatigue,
    int? mood,
    int? sleepiness,
    String? note,
  })  : energy = Rating(energy),
        focus = Rating(focus),
        fatigue = Rating(fatigue),
        mood = mood != null ? Rating(mood) : null,
        sleepiness = sleepiness != null ? Rating(sleepiness) : null,
        note = validateNoteLength(note),
        super(date: normalizeToDay(date));

  @override
  DailyStateEntry copyWith({
    String? id,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? energy,
    int? focus,
    int? fatigue,
    int? mood,
    int? sleepiness,
    String? note,
    bool clearNote = false,
    bool clearMood = false,
    bool clearSleepiness = false,
  }) {
    final moodVal = clearMood ? null : (mood ?? this.mood?.value);
    final sleepinessVal = clearSleepiness ? null : (sleepiness ?? this.sleepiness?.value);
    return DailyStateEntry(
      id: id ?? this.id,
      date: normalizeToDay(date ?? this.date),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      energy: energy ?? this.energy.value,
      focus: focus ?? this.focus.value,
      fatigue: fatigue ?? this.fatigue.value,
      mood: moodVal,
      sleepiness: sleepinessVal,
      note: clearNote ? null : (note ?? this.note),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        ...super.props,
        energy,
        focus,
        fatigue,
        mood,
        sleepiness,
        note,
      ];
}
