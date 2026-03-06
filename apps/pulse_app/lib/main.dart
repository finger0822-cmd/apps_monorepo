import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/pulse_dependencies.dart';
import 'l10n/app_localizations.dart';
import 'ui/today_log_screen.dart';

// Insights 縦スライスを動かす場合: openIsar(extraSchemas: [IsarInsightEntitySchema]) で開き、
// IsarDb.setInstance(isar) のあと、PulseEventRepository/InsightRepository/GenerateInsightsUsecase を組み立てて
// home: InsightsPage(...) に差し込む。詳細は lib/features/pulse/README.md を参照。

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final deps = await PulseDependencies.bootstrap();
    runApp(PulseApp(deps: deps));
  } catch (e, st) {
    runApp(_LaunchErrorApp(message: e.toString(), stackTrace: st.toString()));
  }
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key, required this.deps});

  final PulseDependencies deps;

  static const _bg = Color(0xFF0F0F0F);
  static const _textMain = Color(0xFFEAEAEA);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _bg,
      canvasColor: _bg,
      colorScheme: const ColorScheme.dark(
        surface: _bg,
        onSurface: _textMain,
      ),
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: _textMain,
            displayColor: _textMain,
          ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: theme,
      darkTheme: theme,
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: TodayLogScreen(deps: deps),
    );
  }
}

/// 起動時（bootstrap / seed）に失敗した場合に表示するエラー画面。
/// 実機・本番でもクラッシュせず原因を把握できるようにする。
class _LaunchErrorApp extends StatelessWidget {
  const _LaunchErrorApp({required this.message, required this.stackTrace});

  final String message;
  final String stackTrace;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF0F0F0F),
          onSurface: Color(0xFFEAEAEA),
          error: Color(0xFFCF6679),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '起動エラー',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SelectableText(
                  message,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
                if (stackTrace.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Stack trace',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    stackTrace,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
