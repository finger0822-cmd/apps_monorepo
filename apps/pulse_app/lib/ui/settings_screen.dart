import 'package:flutter/material.dart';

import '../core/pulse_dependencies.dart';
import '../l10n/app_localizations.dart';

/// ご利用にあたって: disclaimer と相談窓口案内。振り返りは主機能のためホーム側メニューへ。
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
