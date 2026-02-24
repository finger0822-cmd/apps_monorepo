import 'package:flutter/material.dart';

import '../../core/pulse_dependencies.dart';
import '../../l10n/app_localizations.dart';
import '../settings_screen.dart';

/// 右上 ⋯ の直下にメニューを出すボタン。操作が上下に分散しないようボタン近くでポップアップ表示する。
/// 設定のみ（傾向分析は2枚目の「傾向分析を見る」から遷移）。
class HomeOverflowButton extends StatelessWidget {
  const HomeOverflowButton({
    super.key,
    required this.deps,
    this.onSettingsPopped,
  });

  final PulseDependencies deps;
  final VoidCallback? onSettingsPopped;

  static const _iconColor = Color(0xFF777777);
  static const _menuBg = Color(0xFF1A1A1A);
  static const _textColor = Color(0xFFC2C2C2);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_horiz, size: 22, color: _iconColor),
      padding: EdgeInsets.zero,
      offset: const Offset(-8, 40),
      color: _menuBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) {
        if (value == 'settings') {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => SettingsScreen(deps: deps),
            ),
          ).then((_) => onSettingsPopped?.call());
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.settingsLabel,
                style: const TextStyle(
                  fontSize: 15,
                  color: _textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 12, color: _iconColor),
            ],
          ),
        ),
      ],
    );
  }
}
