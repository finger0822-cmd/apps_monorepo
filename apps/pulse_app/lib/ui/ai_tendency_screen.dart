import 'package:core_state/core_state.dart';
import 'package:flutter/material.dart';

import '../core/pulse_dependencies.dart';
import '../l10n/app_localizations.dart';

/// 3枚目：60/90/120日のAI傾向分析。蓄積データの統計・要約を表示する。
/// 現時点はMVP雛形（プレースホルダ）。AI接続は後段で実装する。
class AiTendencyScreen extends StatefulWidget {
  const AiTendencyScreen({super.key, required this.deps});

  final PulseDependencies deps;

  @override
  State<AiTendencyScreen> createState() => _AiTendencyScreenState();
}

class _AiTendencyScreenState extends State<AiTendencyScreen> {
  int _periodDays = 60;
  List<DailyStateEntry>? _entries;

  static const _periods = [60, 90, 120];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final count = _periodDays.clamp(60, 150);
    final list = await widget.deps.repo.latest(count);
    if (!mounted) return;
    setState(() => _entries = list);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F0F0F);
    const textColor = Color(0xFFC2C2C2);
    const mutedColor = Color(0xFF777777);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: bg,
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
                      color: mutedColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    l10n.tendencyAnalysisLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 期間切替（60 / 90 / 120日）
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _periods
                          .map((d) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _periodDays = d;
                                      _load();
                                    });
                                  },
                                  child: Text(
                                    '${d}日',
                                    style: TextStyle(
                                      fontSize: _periodDays == d ? 14 : 13,
                                      fontWeight:
                                          _periodDays == d ? FontWeight.w500 : FontWeight.w400,
                                      color: _periodDays == d ? textColor : mutedColor,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                    // AI要約（プレースホルダ）
                    Text(
                      l10n.aiSummarySection,
                      style: const TextStyle(
                        fontSize: 12,
                        color: mutedColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'この期間の記録を要約する機能は、後日接続されます。おおむね傾向が把握できるような表現で表示する予定です。',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 項目別傾向（プレースホルダ）
                    Text(
                      l10n.perMetricTrendSection,
                      style: const TextStyle(
                        fontSize: 12,
                        color: mutedColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${l10n.energy} / ${l10n.focus} / ${l10n.fatigue} の傾向は、AI接続後に表示されます。',
                      style: const TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 変動（プレースホルダ）
                    Text(
                      l10n.variabilitySection,
                      style: const TextStyle(
                        fontSize: 12,
                        color: mutedColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '変動の大きさ（安定している／波がある）は、統計算出後に表示されます。',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Divider(height: 1, color: mutedColor),
                    const SizedBox(height: 16),
                    Text(
                      l10n.tendencyDisclaimer,
                      style: const TextStyle(
                        fontSize: 12,
                        color: mutedColor,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
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
