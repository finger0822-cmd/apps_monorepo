import 'package:isar/isar.dart';

part 'mind_entry.g.dart';

/// アプリの唯一のデータモデル。
/// 通常日記とタイムカプセルの両方を兼ねる。
@collection
class MindEntry {
  MindEntry({
    required this.text,
    required this.energy,
    required this.focus,
    required this.fatigue,
    required this.mood,
    required this.sleepiness,
    required this.createdAt,
    this.capsuleNote,
    this.openOn,
    this.openedAt,
    this.aiFeedback,
    this.aiFeedbackLoaded = false,
    this.aiComparison,
    this.aiComparisonLoaded = false,
  });

  Id id = Isar.autoIncrement;

  // ── 基本フィールド ─────────────────────────────
  late String text; // 日記本文
  late int energy; // 気力    1〜5
  late int focus; // 集中    1〜5
  late int fatigue; // 疲れ    1〜5
  late int mood; // 気分    1〜5
  late int sleepiness; // 眠気    1〜5

  @Index()
  late DateTime createdAt;

  // ── タイムカプセル ────────────────────────────
  String? capsuleNote; // 未来の自分へのメッセージ（任意）
  DateTime? openOn; // 開封予定日（nullなら通常日記）
  DateTime? openedAt; // 開封済み日時（nullなら未開封）

  // ── AI分析 ───────────────────────────────────
  String? aiFeedback; // 今日の要約
  bool aiFeedbackLoaded = false;
  String? aiComparison; // 過去との比較分析（タイムカプセル開封時）
  bool aiComparisonLoaded = false;

  // ── 便利ゲッター ─────────────────────────────
  bool get isTimeCapsule => openOn != null;
  bool get isOpened => openedAt != null;
  bool get isSealed => isTimeCapsule && !isOpened;
  double get averageScore =>
      (energy + focus + (5 - fatigue) + mood + (5 - sleepiness)) / 5.0;
}
