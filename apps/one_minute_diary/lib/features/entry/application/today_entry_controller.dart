import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/entry_repository.dart';
import 'timer_controller.dart';

final todayEntryControllerProvider =
    StateNotifierProvider<TodayEntryController, TodayEntryState>(
  (ref) => TodayEntryController(ref, ref.watch(entryRepositoryProvider)),
);

class TodayEntryController extends StateNotifier<TodayEntryState> {
  TodayEntryController(this._ref, this._repository)
      : _timer = OneMinuteTimerController(
          onTick: (_) {},
          onFinished: () async {},
        ),
        super(TodayEntryState.initial()) {
    _timer.dispose();
    _timer = OneMinuteTimerController(
      onTick: _onTick,
      onFinished: _onTimerFinished,
    );
    _initialize();
  }

  final Ref _ref;
  final EntryRepository _repository;
  late OneMinuteTimerController _timer;

  Future<void> _initialize() async {
    final existing = await _repository.findToday();
    if (!mounted) {
      return;
    }
    if (existing != null) {
      state = state.copyWith(
        isLoading: false,
        text: existing.text,
        isReadOnly: true,
        hasSavedEntry: true,
        timerStarted: true,
        remainingSeconds: 0,
      );
      return;
    }
    state = state.copyWith(isLoading: false);
  }

  void onTextChanged(String value) {
    if (state.isReadOnly) {
      return;
    }

    state = state.copyWith(text: value);
    if (!state.timerStarted && value.isNotEmpty) {
      _timer.start();
      state = state.copyWith(timerStarted: true);
    }
  }

  void _onTick(int remainingSeconds) {
    if (!mounted) {
      return;
    }
    state = state.copyWith(remainingSeconds: remainingSeconds);
  }

  Future<void> _onTimerFinished() async {
    if (!mounted) {
      return;
    }
    state = state.copyWith(isReadOnly: true, remainingSeconds: 0);
    await _saveIfNeeded();
  }

  Future<void> _saveIfNeeded() async {
    final text = state.text.trim();
    if (text.isEmpty || state.hasSavedEntry) {
      return;
    }

    await _repository.upsertToday(text);
    if (!mounted) {
      return;
    }

    state = state.copyWith(hasSavedEntry: true);
    _ref.invalidate(allEntriesProvider);
  }

  @override
  void dispose() {
    _timer.dispose();
    super.dispose();
  }
}

class TodayEntryState {
  const TodayEntryState({
    required this.isLoading,
    required this.text,
    required this.isReadOnly,
    required this.remainingSeconds,
    required this.timerStarted,
    required this.hasSavedEntry,
  });

  factory TodayEntryState.initial() {
    return const TodayEntryState(
      isLoading: true,
      text: '',
      isReadOnly: false,
      remainingSeconds: 60,
      timerStarted: false,
      hasSavedEntry: false,
    );
  }

  final bool isLoading;
  final String text;
  final bool isReadOnly;
  final int remainingSeconds;
  final bool timerStarted;
  final bool hasSavedEntry;

  TodayEntryState copyWith({
    bool? isLoading,
    String? text,
    bool? isReadOnly,
    int? remainingSeconds,
    bool? timerStarted,
    bool? hasSavedEntry,
  }) {
    return TodayEntryState(
      isLoading: isLoading ?? this.isLoading,
      text: text ?? this.text,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      timerStarted: timerStarted ?? this.timerStarted,
      hasSavedEntry: hasSavedEntry ?? this.hasSavedEntry,
    );
  }
}
