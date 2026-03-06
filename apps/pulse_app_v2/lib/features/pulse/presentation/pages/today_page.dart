import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_app/billing/billing_providers.dart';
import 'package:pulse_app/billing/paywall_screen.dart';
import 'package:pulse_app/features/pulse/application/providers/pulse_providers.dart';
import 'package:pulse_app/features/pulse/domain/metrics/pulse_metric.dart';
import 'package:pulse_app/features/pulse/presentation/pages/insights_page.dart';
import 'package:pulse_app/l10n/app_localizations.dart';

/// Today: 今日の状態の記録（入力専用）。5項目を共通定義から表示。
const _circleSizeSelected = 50.0;
const _circleSizeUnselected = 42.0;
const _circleGap = 12.0;
const _rowWidth = _circleSizeSelected * 5 + _circleGap * 4;

const _sectionSpacing = 10.0;
const _labelToAxisSpacing = 5.0;
const _axisToButtonsSpacing = 8.0;

class TodayPage extends ConsumerStatefulWidget {
  const TodayPage({super.key});

  @override
  ConsumerState<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends ConsumerState<TodayPage> {
  static const _bg = Color(0xFF0F0F0F);

  late List<int> _values;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    assert(
      PulseMetric.all.length == 5,
      'PulseMetric.all must have 5 items, got ${PulseMetric.all.length}',
    );
    _values = List.filled(5, 3);
  }

  void _onValueChanged(int index, int v) {
    setState(() {
      _values[index] = v.clamp(1, 5);
    });
  }

  bool get _isValid {
    const min = 1;
    const max = 5;
    return _values.length >= 5 && _values.every((v) => v >= min && v <= max);
  }

  static void _showMetricExplanation(BuildContext context, PulseMetric metric) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(metric.descriptionTitle),
        content: SingleChildScrollView(child: Text(metric.descriptionBody)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }

  Future<void> _onNextPressed() async {
    if (!_isValid || _saving) return;

    _saving = true;
    setState(() {});

    final usecase = ref.read(dailyStateUpsertUsecaseProvider);
    try {
      await usecase.upsertForDate(
        date: DateTime.now(),
        energy: _values[0],
        focus: _values[1],
        fatigue: _values[2],
        mood: _values[3],
        sleepiness: _values[4],
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存しました'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        _saving = false;
        setState(() {});
      }
    }
  }

  void _onAiSummaryPressed() {
    final ent = ref.read(entitlementProvider).valueOrNull;
    if (ent?.isPro == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pro機能です（仮）'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const PaywallScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = _isValid && !_saving;
    final l10n = AppLocalizations.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const InsightsPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'インサイト',
                        style: TextStyle(
                          color: Color(0xFFEAEAEA),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _onAiSummaryPressed,
                      child: const Text(
                        'AI要約',
                        style: TextStyle(
                          color: Color(0xFFEAEAEA),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: SizedBox(
                        width: _rowWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (int i = 0; i < 5; i++) ...[
                              if (i > 0)
                                const SizedBox(height: _sectionSpacing),
                              _MetricRow(
                                metric: PulseMetric.all[i],
                                value: _values[i],
                                onChanged: (v) => _onValueChanged(i, v),
                                onLongPressLabel: () => _showMetricExplanation(
                                  context,
                                  PulseMetric.all[i],
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: canProceed && !_saving
                                    ? _onNextPressed
                                    : null,
                                behavior: HitTestBehavior.opaque,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 120),
                                  opacity: canProceed ? 0.75 : 0.25,
                                  child: Text(
                                    '${l10n.nextLabel} →',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFEAEAEA),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.metric,
    required this.value,
    required this.onChanged,
    required this.onLongPressLabel,
  });

  final PulseMetric metric;
  final int value;
  final ValueChanged<int> onChanged;
  final VoidCallback onLongPressLabel;

  static const _labelColor = Color(0xFFC2C2C2);
  static const _axisColor = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: GestureDetector(
            onLongPress: onLongPressLabel,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                metric.nameJa,
                style: const TextStyle(
                  color: _labelColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: _labelToAxisSpacing),
        SizedBox(
          width: _rowWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    metric.leftLabel,
                    style: const TextStyle(
                      color: _axisColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    metric.rightLabel,
                    style: const TextStyle(
                      color: _axisColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _axisToButtonsSpacing),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (TapDownDetails details) {
                  final width = _rowWidth;
                  final tapX = details.localPosition.dx;
                  final v = ((tapX / width) * 5).floor() + 1;
                  onChanged(v.clamp(1, 5));
                },
                child: SizedBox(
                  width: _rowWidth,
                  height: _circleSizeSelected,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < 5; i++) ...[
                        if (i > 0) const SizedBox(width: _circleGap),
                        _RatingDot(value: i + 1, selected: (i + 1) == value),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RatingDot extends StatelessWidget {
  const _RatingDot({required this.value, required this.selected});

  final int value;
  final bool selected;

  static const _unselectedText = Color(0xFF8A8A8A);
  static const _unselectedBorder = Color(0xFF222222);
  static const _selectedBorder = Color(0xFF4A4A4A);
  static const _selectedText = Color(0xFFEAEAEA);
  static const _sizeDuration = Duration(milliseconds: 90);

  @override
  Widget build(BuildContext context) {
    final size = selected ? _circleSizeSelected : _circleSizeUnselected;
    return SizedBox(
      width: _circleSizeSelected,
      height: _circleSizeSelected,
      child: Center(
        child: AnimatedContainer(
          duration: _sizeDuration,
          curve: Curves.linear,
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(
              color: selected ? _selectedBorder : _unselectedBorder,
              width: selected ? 1.8 : 1.0,
            ),
          ),
          child: Text(
            '$value',
            style: TextStyle(
              color: selected ? _selectedText : _unselectedText,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
