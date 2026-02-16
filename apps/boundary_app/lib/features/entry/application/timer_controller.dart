import 'dart:async';

class OneMinuteTimerController {
  OneMinuteTimerController({
    required this.onTick,
    required this.onFinished,
    this.totalSeconds = 60,
  });

  final void Function(int remainingSeconds) onTick;
  final Future<void> Function() onFinished;
  final int totalSeconds;

  Timer? _timer;
  bool _started = false;
  late int _remainingSeconds = totalSeconds;

  bool get started => _started;
  int get remainingSeconds => _remainingSeconds;

  void start() {
    if (_started) {
      return;
    }
    _started = true;
    _remainingSeconds = totalSeconds;
    onTick(_remainingSeconds);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      _remainingSeconds -= 1;
      onTick(_remainingSeconds);
      if (_remainingSeconds <= 0) {
        timer.cancel();
        await onFinished();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
