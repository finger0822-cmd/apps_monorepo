// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get energy => 'Energy';

  @override
  String get focus => 'Focus';

  @override
  String get fatigue => 'Fatigue';

  @override
  String get nextLabel => 'Record';

  @override
  String get trendLabel => 'Trend';

  @override
  String get tendencyAnalysisLabel => 'Tendency analysis';

  @override
  String get viewTendencyAnalysisLink => 'View tendency analysis';

  @override
  String get settingsLabel => 'Settings';

  @override
  String get disclaimerBody =>
      'Pulse is not for medical diagnosis or treatment. It is a tool to observe your daily state.\nIf you are in distress or crisis, please contact a professional support service.';

  @override
  String get crisisHelp => 'Crisis support';

  @override
  String get ahaTitle => 'Pulse is starting to see your wave';

  @override
  String get continueLabel => 'Continue';

  @override
  String get aiSummarySection => 'AI summary';

  @override
  String get perMetricTrendSection => 'Per-metric trends';

  @override
  String get variabilitySection => 'Variability';

  @override
  String get tendencyDisclaimer =>
      'Not for medical diagnosis or treatment. For reference only.';
}
