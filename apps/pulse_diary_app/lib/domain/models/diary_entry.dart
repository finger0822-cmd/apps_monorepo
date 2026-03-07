import 'package:isar/isar.dart';

part 'diary_entry.g.dart';

@collection
class DiaryEntry {
  DiaryEntry({
    required this.text,
    required this.energy,
    required this.focus,
    required this.fatigue,
    required this.mood,
    required this.sleepiness,
    required this.createdAt,
    this.aiFeedback,
    this.aiFeedbackLoaded = false,
    this.photoPath,
  });

  Id id = Isar.autoIncrement;

  late String text;
  late int energy;     // 気力 1〜5
  late int focus;      // 集中 1〜5
  late int fatigue;    // 疲れ 1〜5
  late int mood;       // 気分 1〜5
  late int sleepiness; // 眠気 1〜5
  late DateTime createdAt;
  String? aiFeedback;
  bool aiFeedbackLoaded = false;
  String? photoPath;
}
