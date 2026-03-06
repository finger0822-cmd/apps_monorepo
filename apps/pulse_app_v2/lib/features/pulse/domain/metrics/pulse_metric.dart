/// 1枚目入力・2枚目観測・3枚目傾向分析で共通参照する項目定義（案A: 5項目）。
/// 表示名・左右ラベル・長押し説明を一箇所で管理し、直書きを避ける。
class PulseMetric {
  const PulseMetric({
    required this.id,
    required this.nameJa,
    required this.leftLabel,
    required this.rightLabel,
    required this.descriptionTitle,
    required this.descriptionBody,
    required this.lowGuide,
    required this.highGuide,
    required this.order,
  });

  final String id;
  final String nameJa;
  final String leftLabel;
  final String rightLabel;
  final String descriptionTitle;
  final String descriptionBody;
  final String lowGuide;
  final String highGuide;
  final int order;

  /// 表示順でソートした5項目（気力・集中・疲れ・気分・眠気）。
  static const List<PulseMetric> all = [
    PulseMetric(
      id: 'energy',
      nameJa: '気力',
      leftLabel: 'わかない',
      rightLabel: 'わく',
      descriptionTitle: '気力',
      descriptionBody: '動き出せそうな感じ、やる気の火がつきやすい感じです。体力とは別で、「やろうと思えるか」を見ます。',
      lowGuide: '動き出しにくい、気持ちが向きにくい',
      highGuide: '取りかかりやすい、前に進めそう',
      order: 1,
    ),
    PulseMetric(
      id: 'focus',
      nameJa: '集中',
      leftLabel: '散る',
      rightLabel: '集中',
      descriptionTitle: '集中',
      descriptionBody: '意識が散りやすいか、ひとつのことに向けやすいかを見ます。',
      lowGuide: '気が散りやすい、切り替わりやすい',
      highGuide: 'ひとつのことに向けやすい',
      order: 2,
    ),
    PulseMetric(
      id: 'fatigue',
      nameJa: '疲れ',
      leftLabel: '少',
      rightLabel: '多',
      descriptionTitle: '疲れ',
      descriptionBody: '心や体の消耗感、だるさ、負荷がたまっている感じを見ます。',
      lowGuide: '疲れは少なめ',
      highGuide: '疲れが強い、休みたい感じがある',
      order: 3,
    ),
    PulseMetric(
      id: 'mood',
      nameJa: '気分',
      leftLabel: '重い',
      rightLabel: '軽い',
      descriptionTitle: '気分',
      descriptionBody: '気持ちの重さ/軽さ、全体のこころの天気のような感覚です。',
      lowGuide: '重め、沈みやすい',
      highGuide: '軽め、少し楽',
      order: 4,
    ),
    PulseMetric(
      id: 'sleepiness',
      nameJa: '眠気',
      leftLabel: '少',
      rightLabel: '強い',
      descriptionTitle: '眠気',
      descriptionBody: '今この瞬間の眠たさ、頭のぼんやり感を見ます。',
      lowGuide: '眠気は少なめ',
      highGuide: '眠気が強い、うとうとしやすい',
      order: 5,
    ),
  ];

  /// id から取得。見つからなければ null。
  static PulseMetric? byId(String id) {
    try {
      return all.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 永続化で使う3項目（気力・集中・疲れ）の id。
  static const List<String> persistedIds = ['energy', 'focus', 'fatigue'];
}
