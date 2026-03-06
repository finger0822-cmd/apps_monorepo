import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'billing/billing_providers.dart';
import 'core/pulse_dependencies.dart';
import 'core/theme/app_theme.dart';
import 'features/pulse/application/providers/pulse_providers.dart';
import 'features/pulse/presentation/pages/today_page.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final deps = await PulseDependencies.bootstrap();
    runApp(
      ProviderScope(
        overrides: [pulseDependenciesProvider.overrideWithValue(deps)],
        child: const PulseApp(),
      ),
    );
  } catch (e, st) {
    runApp(_LaunchErrorApp(message: e.toString(), stackTrace: st.toString()));
  }
}

class PulseApp extends ConsumerWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(entitlementProvider);
    final theme = AppTheme.darkTheme;
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
      home: const TodayPage(),
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
      theme: AppTheme.launchErrorTheme,
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
