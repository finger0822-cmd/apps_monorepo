/// 日次状態のドメインエンティティ。
/// 5項目（気力/集中/疲れ/気分/眠気）を 1〜5 で保持。core_state に依存せず domain 層のみで完結する。
class DailyState {
  const DailyState({
    required this.id,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    required this.energy,
    required this.focus,
    required this.fatigue,
    required this.mood,
    required this.sleepiness,
    this.note,
  });

  final String id;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int energy;
  final int focus;
  final int fatigue;
  final int mood;
  final int sleepiness;
  final String? note;

  DailyState copyWith({
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
  }) {
    return DailyState(
      id: id ?? this.id,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      energy: energy ?? this.energy,
      focus: focus ?? this.focus,
      fatigue: fatigue ?? this.fatigue,
      mood: mood ?? this.mood,
      sleepiness: sleepiness ?? this.sleepiness,
      note: clearNote ? null : (note ?? this.note),
    );
  }
}
