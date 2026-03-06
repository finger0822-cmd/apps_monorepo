/// 0〜100 の整数スコア。範囲外は例外。
class Score100 {
  const Score100._(this.value);

  static bool _inRange(int v) => v >= 0 && v <= 100;

  final int value;

  factory Score100(int value) {
    if (!_inRange(value)) {
      throw ArgumentError('Score100 は 0〜100 である必要があります: $value');
    }
    return Score100._(value);
  }
}
