/// ヘッダー用の短文観測解釈。命令・医療・断定を出さない。
class HeaderInsightResult {
  const HeaderInsightResult({
    required this.message,
    this.tag,
  });

  final String message;
  final String? tag;
}

/// 直近の waveScore リストから 1 行の観測文を生成。
/// [waveScores] は直近日付順（古い→新しい）。7 要素想定。
/// entries.length < 3 のときは呼び出し側で渡さず、message が空の結果を返す。
HeaderInsightResult buildHeaderInsight(List<double> waveScores) {
  if (waveScores.length < 3) {
    return const HeaderInsightResult(message: '');
  }

  // 直近3日 vs その前3日の平均差で傾向を判定
  String trendMessage = '';
  String tag = '';

  if (waveScores.length >= 6) {
    final recent3 = _avg(waveScores.sublist(waveScores.length - 3, waveScores.length));
    final prev3 = _avg(waveScores.sublist(waveScores.length - 6, waveScores.length - 3));
    final diff = recent3 - prev3;
    const threshold = 0.2;

    if (diff > threshold) {
      trendMessage = 'ここ数日は少し上向きの傾向かもしれません';
      tag = '上向き';
    } else if (diff < -threshold) {
      trendMessage = 'ここ数日は少し下向きの傾向かもしれません';
      tag = '下向き';
    } else {
      trendMessage = 'おおむね安定した波のようです';
      tag = '安定';
    }
  } else {
    trendMessage = 'おおむね安定した波のようです';
    tag = '安定';
  }

  // 振れ幅（直近7日 or 全件）
  final span = waveScores.isEmpty ? 0.0 : _span(waveScores);
  String spanSuffix = '';
  if (span > 2.0) {
    spanSuffix = '振れ幅がやや大きい一週間かもしれません';
  } else if (span < 1.0 && waveScores.length >= 6) {
    spanSuffix = '振れは小さめです';
  }

  final message = spanSuffix.isEmpty ? trendMessage : '$trendMessage。$spanSuffix';
  return HeaderInsightResult(message: message, tag: tag.isEmpty ? null : tag);
}

double _avg(List<double> xs) {
  if (xs.isEmpty) return 0;
  return xs.reduce((a, b) => a + b) / xs.length;
}

double _span(List<double> xs) {
  if (xs.isEmpty) return 0;
  final min = xs.reduce((a, b) => a < b ? a : b);
  final max = xs.reduce((a, b) => a > b ? a : b);
  return max - min;
}
