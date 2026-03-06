// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get energy => '体力';

  @override
  String get focus => '集中';

  @override
  String get fatigue => '疲れ';

  @override
  String get nextLabel => '記録';

  @override
  String get trendLabel => '振り返り';

  @override
  String get tendencyAnalysisLabel => '傾向分析';

  @override
  String get viewTendencyAnalysisLink => '傾向分析を見る';

  @override
  String get settingsLabel => 'ご利用にあたって';

  @override
  String get disclaimerBody =>
      'Pulseは医療・診断・治療のためのアプリではありません。日々の状態を観測するためのツールです。\nつらいときや緊急のときは、専門の相談窓口にご連絡ください。';

  @override
  String get crisisHelp => '専門の相談窓口';

  @override
  String get ahaTitle => 'Pulseがあなたの波を見つけ始めました';

  @override
  String get continueLabel => '続ける';

  @override
  String get aiSummarySection => 'AI要約';

  @override
  String get perMetricTrendSection => '項目別傾向';

  @override
  String get variabilitySection => '変動';

  @override
  String get tendencyDisclaimer => '医療・診断・治療のためのものではありません。傾向の参考としてご利用ください。';
}
