import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pulse_diary_app/features/diary_write/presentation/screens/diary_write_screen.dart';
import 'package:pulse_diary_app/features/insights/presentation/screens/insights_screen.dart';
import 'package:pulse_diary_app/features/settings/presentation/screens/settings_screen.dart';

/// 5項目の表示用定義（pulse_app_v2 PulseMetric と同様の文言をローカルで定義）
class _MetricDef {
  const _MetricDef({
    required this.nameJa,
    required this.leftLabel,
    required this.rightLabel,
  });
  final String nameJa;
  final String leftLabel;
  final String rightLabel;
}

const _metrics = [
  _MetricDef(nameJa: '気力', leftLabel: 'わかない', rightLabel: 'わく'),
  _MetricDef(nameJa: '集中', leftLabel: '散る', rightLabel: '集中'),
  _MetricDef(nameJa: '疲れ', leftLabel: '少', rightLabel: '多'),
  _MetricDef(nameJa: '気分', leftLabel: '重い', rightLabel: '軽い'),
  _MetricDef(nameJa: '眠気', leftLabel: '少', rightLabel: '強い'),
];

const _circleSizeSelected = 50.0;
const _circleSizeUnselected = 42.0;
const _circleGap = 12.0;
const _rowWidth = _circleSizeSelected * 5 + _circleGap * 4;
const _sectionSpacing = 10.0;
const _labelToAxisSpacing = 5.0;
const _axisToButtonsSpacing = 8.0;

class TodayLogScreen extends ConsumerStatefulWidget {
  const TodayLogScreen({super.key});

  @override
  ConsumerState<TodayLogScreen> createState() => _TodayLogScreenState();
}

class _TodayLogScreenState extends ConsumerState<TodayLogScreen> {
  static const _bg = Color(0xFF0F0F0F);

  late List<int> _values;

  @override
  void initState() {
    super.initState();
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

  void _onNextPressed() {
    if (!_isValid) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => DiaryWriteScreen(
          energy: _values[0],
          focus: _values[1],
          fatigue: _values[2],
          mood: _values[3],
          sleepiness: _values[4],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = _isValid;

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.insights_outlined, color: Color(0xFF777777), size: 20),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const InsightsScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Color(0xFF777777), size: 20),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
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
                                metric: _metrics[i],
                                value: _values[i],
                                onChanged: (v) => _onValueChanged(i, v),
                              ),
                            ],
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: canProceed ? _onNextPressed : null,
                                behavior: HitTestBehavior.opaque,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 120),
                                  opacity: canProceed ? 0.75 : 0.25,
                                  child: const Text(
                                    '次へ →',
                                    style: TextStyle(
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
  });

  final _MetricDef metric;
  final int value;
  final ValueChanged<int> onChanged;

  static const _labelColor = Color(0xFFC2C2C2);
  static const _axisColor = Color(0xFF777777);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
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
