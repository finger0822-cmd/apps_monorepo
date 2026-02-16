import 'package:isar/isar.dart';

part 'entry.g.dart';

@collection
class Entry {
  Entry({
    required this.date,
    required this.text,
    required this.createdAt,
  });

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String date;

  late String text;
  late DateTime createdAt;
}
