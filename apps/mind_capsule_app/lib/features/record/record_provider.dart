import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/app_providers.dart';
import '../../domain/models/mind_entry.dart';

const _kTimerUsedKey = 'timer_used_date';

/// 記録画面の状態
class RecordState {
  const RecordState({
    this.energy = 3,
    this.focus = 3,
    this.fatigue = 3,
    this.mood = 3,
    this.sleepiness = 3,
    this.text = '',
    this.isSaving = false,
    this.saveError,
    this.savedEntryId,
    this.aiFeedback,
    this.aiFeedbackLoading = false,
    this.timerUsedToday = false,
    this.alreadySavedToday = false,
  });

  final int energy;
  final int focus;
  final int fatigue;
  final int mood;
  final int sleepiness;
  final String text;
  final bool isSaving;
  final String? saveError;
  final int? savedEntryId;
  final String? aiFeedback;
  final bool aiFeedbackLoading;
  final bool timerUsedToday;
  final bool alreadySavedToday;

  RecordState copyWith({
    int? energy,
    int? focus,
    int? fatigue,
    int? mood,
    int? sleepiness,
    String? text,
    bool? isSaving,
    String? saveError,
    int? savedEntryId,
    String? aiFeedback,
    bool? aiFeedbackLoading,
    bool? timerUsedToday,
    bool? alreadySavedToday,
  }) {
    return RecordState(
      energy: energy ?? this.energy,
      focus: focus ?? this.focus,
      fatigue: fatigue ?? this.fatigue,
      mood: mood ?? this.mood,
      sleepiness: sleepiness ?? this.sleepiness,
      text: text ?? this.text,
      isSaving: isSaving ?? this.isSaving,
      saveError: saveError ?? this.saveError,
      savedEntryId: savedEntryId ?? this.savedEntryId,
      aiFeedback: aiFeedback ?? this.aiFeedback,
      aiFeedbackLoading: aiFeedbackLoading ?? this.aiFeedbackLoading,
      timerUsedToday: timerUsedToday ?? this.timerUsedToday,
      alreadySavedToday: alreadySavedToday ?? this.alreadySavedToday,
    );
  }
}

class RecordNotifier extends Notifier<RecordState> {
  @override
  RecordState build() {
    _initFromPrefs();
    return const RecordState();
  }

  Future<void> _initFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayStr();
    final timerDate = prefs.getString(_kTimerUsedKey);
    final timerUsed = timerDate == today;

    final repo = ref.read(entryRepositoryProvider);
    final all = await repo.getAll();
    final now = DateTime.now();
    final savedToday = all.any((e) =>
        e.openOn == null &&
        e.createdAt.year == now.year &&
        e.createdAt.month == now.month &&
        e.createdAt.day == now.day);

    state = state.copyWith(
      timerUsedToday: timerUsed,
      alreadySavedToday: savedToday,
    );
  }

  String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  void setEnergy(int v) => state = state.copyWith(energy: v.clamp(1, 5));
  void setFocus(int v) => state = state.copyWith(focus: v.clamp(1, 5));
  void setFatigue(int v) => state = state.copyWith(fatigue: v.clamp(1, 5));
  void setMood(int v) => state = state.copyWith(mood: v.clamp(1, 5));
  void setSleepiness(int v) => state = state.copyWith(sleepiness: v.clamp(1, 5));
  void setText(String v) => state = state.copyWith(text: v, saveError: '');

  Future<void> setTimerUsedToday(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    if (v) {
      await prefs.setString(_kTimerUsedKey, _todayStr());
    } else {
      await prefs.remove(_kTimerUsedKey);
    }
    state = state.copyWith(timerUsedToday: v);
  }

  Future<void> save(String language) async {
    if (state.isSaving) return;

    // DB直接確認（二重チェック）
    final repo = ref.read(entryRepositoryProvider);
    final all = await repo.getAll();
    final now = DateTime.now();
    final savedToday = all.any((e) =>
        e.openOn == null &&
        e.createdAt.year == now.year &&
        e.createdAt.month == now.month &&
        e.createdAt.day == now.day);
    if (savedToday) {
      state = state.copyWith(
        alreadySavedToday: true,
        saveError: '今日はすでに記録済みです。明日またどうぞ 😊',
      );
      return;
    }

    if (state.text.trim().isEmpty) {
      state = state.copyWith(saveError: '日記を入力してください');
      return;
    }

    state = state.copyWith(
      isSaving: true,
      saveError: '',
      aiFeedback: null,
      aiFeedbackLoading: true,
    );

    final entry = MindEntry(
      text: state.text.trim(),
      energy: state.energy,
      focus: state.focus,
      fatigue: state.fatigue,
      mood: state.mood,
      sleepiness: state.sleepiness,
      createdAt: DateTime.now(),
    );

    try {
      await repo.save(entry);
      state = state.copyWith(
        isSaving: false,
        savedEntryId: entry.id,
        saveError: '',
        alreadySavedToday: true,
      );
      final feedback = await repo.fetchAiFeedback(entry.id, language);
      state = state.copyWith(
        aiFeedback: feedback,
        aiFeedbackLoading: false,
      );
    } catch (e, st) {
      state = state.copyWith(
        isSaving: false,
        aiFeedbackLoading: false,
        saveError: e.toString().contains('今日はすでに記録済みです')
            ? '今日はすでに記録済みです。明日またどうぞ 😊'
            : '保存に失敗しました: $e',
      );
      assert(() {
        // ignore: avoid_print
        print('RecordNotifier.save error: $e\n$st');
        return true;
      }());
    }
  }

  void reset() {
    state = RecordState(
      timerUsedToday: state.timerUsedToday,
      alreadySavedToday: state.alreadySavedToday,
    );
  }
}

final recordProvider =
    NotifierProvider<RecordNotifier, RecordState>(RecordNotifier.new);
