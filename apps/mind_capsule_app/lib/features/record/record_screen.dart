import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/services/subscription_service.dart';
import '../../core/theme/app_theme.dart';
import '../history/history_provider.dart';
import '../settings/settings_provider.dart';
import 'record_provider.dart';

Color _scoreBadgeColor(int value, int index) {
  final isInverted = index == 2 || index == 4;
  final effective = isInverted ? (6 - value) : value;
  if (effective <= 2) return const Color(0xFFD32F2F);
  if (effective >= 4) return const Color(0xFF2E7D32);
  return Colors.grey;
}

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  final _textController = TextEditingController();
  Timer? _timer;
  int _countdownSeconds = 60;
  bool _timerEnabled = false;

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    final state = ref.read(recordProvider);
    if (state.timerUsedToday && !_timerEnabled) return;
    setState(() {
      _timerEnabled = !_timerEnabled;
      if (_timerEnabled) {
        _countdownSeconds = 60;
        ref.read(recordProvider.notifier).setTimerUsedToday(true);
        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;
          setState(() {
            if (_countdownSeconds > 0) {
              _countdownSeconds--;
            } else {
              _timer?.cancel();
            }
          });
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordProvider);
    final lang = ref.watch(appLanguageProvider);
    final s = AppStrings.of(lang);
    final labels = s.axisLabels;
    final timerActive = _timerEnabled && _countdownSeconds > 0;

    // 今日記録済みの場合
    if (state.alreadySavedToday && state.savedEntryId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(s.recordTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('✅', style: TextStyle(fontSize: 72)),
                const SizedBox(height: 24),
                Text(
                  s.alreadySavedTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6A3DE8),
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  s.alreadySavedSubtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.recordTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // 5軸カード
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            shadowColor: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: List.generate(5, (i) {
                  final value = [
                    state.energy,
                    state.focus,
                    state.fatigue,
                    state.mood,
                    state.sleepiness
                  ][i];
                  final setter = [
                    ref.read(recordProvider.notifier).setEnergy,
                    ref.read(recordProvider.notifier).setFocus,
                    ref.read(recordProvider.notifier).setFatigue,
                    ref.read(recordProvider.notifier).setMood,
                    ref.read(recordProvider.notifier).setSleepiness,
                  ][i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 64,
                          child: Text(labels[i],
                              style: const TextStyle(fontSize: 13)),
                        ),
                        Expanded(
                          child: Slider(
                            value: value.toDouble(),
                            min: 1,
                            max: 5,
                            divisions: 4,
                            onChanged: (v) => setter(v.round()),
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _scoreBadgeColor(value, i),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$value',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 1分タイマーカード
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            shadowColor: Colors.black12,
            color: _timerEnabled
                ? const Color(0xFF6A3DE8)
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: _timerEnabled ? Colors.white : const Color(0xFF6A3DE8),
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.timerUsedToday && !_timerEnabled
                              ? s.timerUsedLabel
                              : s.timerLabel,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _timerEnabled
                                ? Colors.white
                                : state.timerUsedToday
                                    ? Colors.grey
                                    : const Color(0xFF6A3DE8),
                          ),
                        ),
                      ),
                      Switch(
                        value: _timerEnabled,
                        onChanged: state.timerUsedToday && !_timerEnabled
                            ? null
                            : (_) => _toggleTimer(),
                        activeColor: Colors.white,
                        activeTrackColor: Colors.white.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                  if (_timerEnabled) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: _countdownSeconds / 60,
                              strokeWidth: 6,
                              backgroundColor:
                                  Colors.white.withValues(alpha: 0.3),
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            s.timerSeconds(_countdownSeconds),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 日記欄
          Container(
            decoration: BoxDecoration(
              color: timerActive
                  ? AppTheme.lightPurple.withValues(alpha: 0.5)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: timerActive
                    ? const Color(0xFF6A3DE8).withValues(alpha: 0.3)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _textController,
              onChanged: timerActive
                  ? (v) => ref.read(recordProvider.notifier).setText(v)
                  : null,
              enabled: timerActive,
              minLines: 6,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: s.diaryLabel,
                labelStyle: TextStyle(
                  color: timerActive
                      ? const Color(0xFF6A3DE8)
                      : Colors.grey,
                ),
                hintText: timerActive
                    ? s.diaryHint
                    : _timerEnabled && _countdownSeconds == 0
                        ? s.diaryHintTimerEnd
                        : s.diaryHintTimerOff,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // エラー表示
          if (state.saveError != null && state.saveError!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.saveError!,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),

          // 保存ボタン
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              gradient: LinearGradient(
                colors: state.isSaving || state.alreadySavedToday
                    ? [Colors.grey.shade400, Colors.grey.shade300]
                    : const [Color(0xFF5E3A8C), Color(0xFF9B7EC8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: state.isSaving || state.alreadySavedToday
                    ? null
                    : () async {
                        await ref
                            .read(recordProvider.notifier)
                            .save(lang);
                        final saved = ref.read(recordProvider);
                        if (saved.saveError == null ||
                            saved.saveError!.isEmpty) {
                          _textController.clear();
                          ref.invalidate(historyEntriesProvider);
                        }
                      },
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: state.isSaving
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            state.alreadySavedToday ? s.savedButton : s.saveButton,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),

          // AI フィードバック
          if (state.savedEntryId != null) ...[
            const SizedBox(height: 24),
            Text(s.aiSummaryTitle,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Consumer(builder: (context, ref, _) {
              final sub = ref.watch(subscriptionProvider).valueOrNull;
              final aiLocked = sub != null && !sub.canUseAi;
              if (aiLocked) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightPurple.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        s.aiLockedMessage,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              if (state.aiFeedbackLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state.aiFeedback != null) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F0FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(state.aiFeedback!,
                      style: const TextStyle(height: 1.6)),
                );
              }
              return Text(
                s.aiNoApiKey,
                style: Theme.of(context).textTheme.bodySmall,
              );
            }),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
