import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

/// AI が生成したインサイト。イミュータブル。scope は対象期間（ローカル日付）。
class Insight {
  const Insight({
    required this.id,
    required this.createdAt,
    required this.scopeLocalDateStart,
    required this.scopeLocalDateEnd,
    required this.summaryText,
    this.bulletPoints,
    this.model,
    this.promptVersion,
  });

  final String id;
  /// 生成日時（UTC）。
  final DateTime createdAt;
  final LocalDate scopeLocalDateStart;
  final LocalDate scopeLocalDateEnd;
  final String summaryText;
  /// 構造化詳細（JSON 文字列）。例: [{"title":"...","body":"..."}]
  final String? bulletPoints;
  /// 使用したモデル識別子（例: "gpt-4", "local"）。
  final String? model;
  /// プロンプトバージョン（例: 1）。
  final int? promptVersion;

  /// 後方互換: generatedAtUtc を createdAt として扱う。
  DateTime get generatedAtUtc => createdAt;
  /// 後方互換: bulletPoints を detailsJson として扱う。
  String? get detailsJson => bulletPoints;
}
