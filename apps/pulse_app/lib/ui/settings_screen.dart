import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/dev/pulse_test_data_seeder.dart';
import '../core/pulse_dependencies.dart';
import '../l10n/app_localizations.dart';

Future<void> _runTestDataSeed(BuildContext context, PulseDependencies deps) async {
  final messenger = ScaffoldMessenger.of(context);
  messenger.showSnackBar(
    const SnackBar(content: Text('テストデータ投入中…')),
  );
  try {
    final seeder = PulseTestDataSeeder(deps);
    final result = await seeder.run(skipExisting: true);
    if (!context.mounted) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          '投入: ${result.inserted}件, スキップ: ${result.skipped}件, 欠損: ${result.missingDays}日\n'
          '${result.from != null ? result.from!.toIso8601String().split('T').first : "—"} 〜 '
          '${result.to != null ? result.to!.toIso8601String().split('T').first : "—"}',
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  } catch (e, st) {
    if (!context.mounted) return;
    messenger.hideCurrentSnackBar();
    debugPrint('PulseTestDataSeeder error: $e\n$st');
    messenger.showSnackBar(
      SnackBar(
        content: Text('投入に失敗しました: $e'),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

/// Settings: disclaimer, crisis help, 開発用. 振り返りは主機能のためホーム側メニューへ。
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.deps});

  final PulseDependencies deps;

  static const _bg = Color(0xFF0F0F0F);
  static const _textColor = Color(0xFFC2C2C2);
  static const _mutedColor = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: _mutedColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    l10n.settingsLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      color: _textColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.disclaimerBody,
                      style: const TextStyle(
                        fontSize: 14,
                        color: _mutedColor,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.crisisHelp,
                      style: const TextStyle(
                        fontSize: 14,
                        color: _textColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'こころの健康相談統一ダイヤル: 0570-064-556\n（平日・土日 24時間）',
                      style: TextStyle(
                        fontSize: 13,
                        color: _mutedColor,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                    if (kDebugMode) ...[
                      const SizedBox(height: 32),
                      const Divider(color: _mutedColor, height: 1),
                      const SizedBox(height: 16),
                      const Text(
                        '開発用',
                        style: TextStyle(
                          fontSize: 12,
                          color: _mutedColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => _runTestDataSeed(context, deps),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _mutedColor,
                          side: const BorderSide(color: _mutedColor),
                        ),
                        child: const Text('テストデータ投入（約60日分）'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
