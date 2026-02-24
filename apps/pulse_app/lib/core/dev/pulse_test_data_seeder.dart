import 'dart:math' as math;

import 'package:core_state/core_state.dart';
import 'package:flutter/foundation.dart';

import '../pulse_dependencies.dart';

/// 開発環境限定で約60日分のテストデータを投入するシーダー。
/// debug ビルド時のみ使用すること。本番では呼ばない。
class PulseTestDataSeeder {
  PulseTestDataSeeder(this._deps);

  final PulseDependencies _deps;

  /// 投入する日数
  static const int daysCount = 60;

  /// 欠損として意図的にスキップする日数
  static const int missingDaysCount = 4;

  /// ベース値（1〜5の中央付近）
  static const double baseValue = 3.0;

  /// 最小表示レンジ的なゆらぎ幅
  static const double _noiseScale = 0.35;

  /// 再現性のための固定シード（欠損日の選び方のみ）
  static const int _seedForMissing = 42;

  /// テストデータを投入する。
  /// [skipExisting] が true のとき、既に同日のデータがある場合はスキップする。
  @visibleForTesting
  Future<PulseTestDataSeederResult> run({bool skipExisting = true}) async {
    if (!kDebugMode) {
      debugPrint('[PulseTestDataSeeder] 本番では実行しません（kDebugMode=false）');
      return PulseTestDataSeederResult(
        inserted: 0,
        skipped: 0,
        missingDays: 0,
        from: null,
        to: null,
      );
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final from = today.subtract(Duration(days: daysCount - 1));
    final to = today;

    final missingIndices = _pickMissingDayIndices(daysCount, missingDaysCount, _seedForMissing);
    int inserted = 0;
    int skipped = 0;

    for (int i = 0; i < daysCount; i++) {
      final date = from.add(Duration(days: i));
      if (missingIndices.contains(i)) continue;

      final existing = await _deps.repo.findByDate(date);
      if (skipExisting && existing != null) {
        skipped++;
        continue;
      }

      final (e, f, g) = _generateDayValues(i, daysCount);
      await _deps.usecase.upsertForDate(
        date: date,
        energy: e,
        focus: f,
        fatigue: g,
        idFactory: (d) => 'seed_${toDateKey(d)}',
      );
      inserted++;
    }

    debugPrint(
      '[PulseTestDataSeeder] 完了: 投入=$inserted, スキップ=$skipped, '
      '欠損日=$missingDaysCount, 期間=${from.toIso8601String().split('T').first}〜${to.toIso8601String().split('T').first}',
    );

    return PulseTestDataSeederResult(
      inserted: inserted,
      skipped: skipped,
      missingDays: missingDaysCount,
      from: from,
      to: to,
    );
  }

  /// 欠損日にする日のインデックスを選ぶ（連続しすぎないようにする）
  Set<int> _pickMissingDayIndices(int totalDays, int count, int seed) {
    final r = math.Random(seed);
    final candidates = List<int>.generate(totalDays, (i) => i);
    candidates.shuffle(r);
    final selected = <int>{};
    for (int i = 0; i < count && i < candidates.length; i++) {
      final idx = candidates[i];
      if (idx > 0 && selected.contains(idx - 1)) continue;
      if (idx < totalDays - 1 && selected.contains(idx + 1)) continue;
      selected.add(idx);
    }
    if (selected.length < count) {
      for (int i = 0; selected.length < count && i < candidates.length; i++) {
        selected.add(candidates[i]);
      }
    }
    return selected;
  }

  /// 1日分の体力・集中・疲れを生成（Pulseらしい静かな変動）
  (int energy, int focus, int fatigue) _generateDayValues(int dayIndex, int totalDays) {
    final t = dayIndex / totalDays;
    double trend;
    double wave;
    if (t < 1 / 3) {
      trend = -0.15;
      wave = 0.08 * math.sin(dayIndex * 0.5);
    } else if (t < 2 / 3) {
      trend = 0.25 * (t - 1 / 3) * 3;
      wave = 0.1 * math.sin(dayIndex * 0.4);
    } else {
      trend = 0.25;
      wave = 0.12 * math.sin(dayIndex * 0.6);
    }
    final noise = (math.Random(dayIndex).nextDouble() - 0.5) * 2 * _noiseScale;
    final raw = baseValue + trend + wave + noise;
    final v = raw.round().clamp(1, 5);
    final fatigueBias = (math.Random(dayIndex + 1).nextDouble() - 0.5) * 0.4;
    final f = (raw + fatigueBias).round().clamp(1, 5);
    final g = (5.5 - raw + (math.Random(dayIndex + 2).nextDouble() - 0.5) * 0.3).round().clamp(1, 5);
    return (v, f, g);
  }
}

/// シーダー実行結果
class PulseTestDataSeederResult {
  PulseTestDataSeederResult({
    required this.inserted,
    required this.skipped,
    required this.missingDays,
    required this.from,
    required this.to,
  });

  final int inserted;
  final int skipped;
  final int missingDays;
  final DateTime? from;
  final DateTime? to;
}
