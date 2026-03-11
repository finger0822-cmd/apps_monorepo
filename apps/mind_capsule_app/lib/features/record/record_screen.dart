import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../core/services/subscription_service.dart';
import '../../core/theme/app_theme.dart';
import '../history/history_provider.dart';
import '../settings/settings_provider.dart';
import 'record_provider.dart';

/// 5軸のラベル＋絵文字（気力・集中・疲れ・気分・眠気）
const _labels = ['気力 ⚡', '集中 🎯', '疲れ 😴', '気分 😊', '眠気 🌙'];

/// スライダー値用のバッジ色（気力・集中・気分は高めが良い、疲れ・眠気は低めが良い）
Color _scoreBadgeColor(int value, int index) {
  final isInverted = index == 2 || index == 4; // 疲れ・眠気
  final effective = isInverted ? (6 - value) : value;
  if (effective <= 2) return const Color(0xFFD32F2F);
  if (effective >= 4) return const Color(0xFF2E7D32);
  return Colors.grey;
}

/// 今日の記録を書く画面。5軸スライダー・日記・タイムカプセル設定・保存後AI要約表示。
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
    if (state.timerUsedToday && !_timerEnabled) return; // 今日すでに使用済み
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('今日の記録'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 5軸スライダー
          ...List.generate(5, (i) {
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
                    child: Text(_labels[i], style: const TextStyle(fontSize: 14)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _scoreBadgeColor(value, i),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$value',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          // 1分タイマー（任意）
          Row(
            children: [
              Text(
                state.timerUsedToday && !_timerEnabled
                    ? '1分タイマー（本日使用済み）'
                    : '1分タイマー',
                style: TextStyle(
                  color: state.timerUsedToday && !_timerEnabled
                      ? Colors.grey
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: _timerEnabled,
                onChanged: state.timerUsedToday && !_timerEnabled
                    ? null // グレーアウト
                    : (_) => _toggleTimer(),
              ),
            ],
          ),
          if (_timerEnabled) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: _countdownSeconds / 60,
                      strokeWidth: 6,
                      backgroundColor: AppTheme.lightPurple,
                    ),
                  ),
                  Text(
                    '$_countdownSeconds秒',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          // 日記本文
          TextField(
            controller: _textController,
            onChanged: _timerEnabled && _countdownSeconds > 0
                ? (v) => ref.read(recordProvider.notifier).setText(v)
                : null,
            enabled: _timerEnabled && _countdownSeconds > 0,
            minLines: 6,
            maxLines: 8,
            decoration: InputDecoration(
              labelText: '今日の日記',
              hintText: _timerEnabled && _countdownSeconds > 0
                  ? '今日はどんな一日でしたか？'
                  : _timerEnabled && _countdownSeconds == 0
                      ? '時間になりました。タイマーを再開してください'
                      : '1分タイマーをONにして書いてください',
              filled: true,
              fillColor: _timerEnabled && _countdownSeconds > 0
                  ? AppTheme.lightPurple.withValues(alpha: 0.5)
                  : Colors.grey.withValues(alpha: 0.15),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
          const SizedBox(height: 16),
          if (state.saveError != null && state.saveError!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.saveError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
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
              gradient: const LinearGradient(
                colors: [Color(0xFF5E3A8C), Color(0xFF9B7EC8)],
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
                        await ref.read(recordProvider.notifier).save(lang);
                        final saved = ref.read(recordProvider);
                        if (saved.saveError == null || saved.saveError!.isEmpty) {
                          _textController.clear();
                          ref.read(recordProvider.notifier).reset();
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
                        : const Text(
                            '保存',
                            style: TextStyle(
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
          // 保存後の AI フィードバック表示
          if (state.savedEntryId != null) ...[
            const SizedBox(height: 24),
            const Text('AI 要約', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      const Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'AI要約は月3回まで（無料）\nプレミアムで無制限',
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
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(state.aiFeedback!),
                );
              }
              return Text(
                'APIキーを設定すると要約が表示されます。',
                style: Theme.of(context).textTheme.bodySmall,
              );
            }),
          ],
        ],
      ),
    );
  }
}
