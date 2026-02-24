import 'package:core_state/core_state.dart';
import 'package:flutter/foundation.dart';

import 'aha_prefs.dart';
import 'pulse_dependencies.dart';

/// Debug only: ensures at least 7 days of entries exist for testing Aha Moment.
/// Seeds past 7 days with varying energy (3,4,3,4,...) so rhythm detection can find a period.
/// Resets hasSeenAhaMoment so the Aha screen is shown again.
Future<void> seed7DaysIfNeeded(PulseDependencies deps) async {
  if (!kDebugMode) return;

  final list = await deps.repo.latest(7);
  if (list.length >= 7) return;

  final now = DateTime.now();
  for (int i = 0; i < 7; i++) {
    final date = DateTime(now.year, now.month, now.day - i);
    final energy = 3 + (i % 2);
    final focus = 3 + (i % 3 == 0 ? 1 : 0);
    final fatigue = 4 - (i % 2);
    await deps.usecase.upsertForDate(
      date: date,
      energy: energy.clamp(1, 5),
      focus: focus.clamp(1, 5),
      fatigue: fatigue.clamp(1, 5),
    );
  }
  await AhaPrefs.setHasSeenAhaMoment(false);
  // ignore: avoid_print
  print('Pulse debug: seeded 7 days for Aha Moment test');
}
