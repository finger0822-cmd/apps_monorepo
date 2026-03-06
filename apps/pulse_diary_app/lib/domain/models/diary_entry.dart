import 'package:isar/isar.dart';

part 'diary_entry.g.dart';

@collection
class DiaryEntry {
  DiaryEntry({
    required this.text,
    required this.moodScore,
    required this.createdAt,
    this.aiFeedback,
    this.aiFeedbackLoaded = false,
    this.photoPath,
  });

  Id id = Isar.autoIncrement;

  late String text;
  late int moodScore; // 1〜5
  late DateTime createdAt;
  String? aiFeedback;
  bool aiFeedbackLoaded = false;
  String? photoPath;
}
