import 'package:core_state/core_state.dart';
import 'package:flutter/material.dart';

import '../core/pulse_dependencies.dart';
import '../domain/weekly/weekly_summary_usecase.dart';
import '../l10n/app_localizations.dart';
import 'widgets/mini_wave_block.dart';

/// Weekly trend: shows the week containing [date] as line charts.
/// No good/bad labels - flow only.
class TrendScreen extends StatefulWidget {
  const TrendScreen({super.key, required this.deps, this.date});

  final PulseDependencies deps;
  final DateTime? date;

  @override
  State<TrendScreen> createState() => _TrendScreenState();
}

class _TrendScreenState extends State<TrendScreen> {
  List<DailyStateEntry>? _weekEntries;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final date = widget.date ?? DateTime.now();
    final entries = await getWeekEntries(widget.deps.repo, date);
    if (!mounted) return;
    setState(() => _weekEntries = entries);
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF0F0F0F);
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
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF777777)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    l10n.trendLabel,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC2C2C2),
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
                child: _weekEntries == null
                    ? const Padding(
                        padding: EdgeInsets.only(top: 48),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF777777),
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : _weekEntries!.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 48),
                            child: Center(
                              child: Text(
                                'この週は記録がありません',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF777777),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          )
                        : MiniWaveBlock(
                            entries: _weekEntries,
                            chartHeight: 56,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
