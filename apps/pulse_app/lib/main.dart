import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/pulse_dependencies.dart';
import 'core/seed_7days.dart';
import 'l10n/app_localizations.dart';
import 'ui/today_log_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final deps = await PulseDependencies.bootstrap();
  await seed7DaysIfNeeded(deps);
  runApp(PulseApp(deps: deps));
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
