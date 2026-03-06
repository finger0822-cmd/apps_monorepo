import 'dart:convert';

import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

/// LLM が返した JSON 文字列を [Insight] にパースする。infrastructure 層。
/// パース失敗時は null を返す。
class InsightResponseParser {
  /// [jsonString] をパースして [Insight] を返す。失敗時は null。
  static Insight? parse(
    String jsonString, {
    required LocalDate scopeStart,
    required LocalDate scopeEnd,
    required DateTime createdAt,
    required String id,
    String? model,
    int? promptVersion,
  }) {
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      final summaryText = map['summaryText'] as String?;
      if (summaryText == null || summaryText.isEmpty) return null;
      final bulletPoints = map['detailsJson'] as String?;
      return Insight(
        id: id,
        createdAt: createdAt,
        scopeLocalDateStart: scopeStart,
        scopeLocalDateEnd: scopeEnd,
        summaryText: summaryText.trim(),
        bulletPoints: bulletPoints != null && bulletPoints.isNotEmpty
            ? bulletPoints.trim()
            : null,
        model: model,
        promptVersion: promptVersion,
      );
    } catch (_) {
      return null;
    }
  }
}
