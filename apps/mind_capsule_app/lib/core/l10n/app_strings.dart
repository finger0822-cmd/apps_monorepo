/// アプリ内文字列の多言語対応
class AppStrings {
  const AppStrings(this.lang);

  final String lang;

  static AppStrings of(String lang) => AppStrings(lang);

  bool get _isEn => lang == 'en';

  // 共通・要求キー
  String get appTitle => _isEn ? 'MindCapsule' : 'MindCapsule';
  String get settings => _isEn ? 'Settings' : '設定';
  String get language => _isEn ? 'Language' : '言語';
  String get notification => _isEn ? 'Notifications' : '通知';
  String get dailyReminder => _isEn ? 'Daily Reminder' : '毎日リマインダー';
  String get subscription => _isEn ? 'Subscription' : 'サブスクリプション';
  String get premiumUpgrade => _isEn ? 'Upgrade to Premium' : 'プレミアムにアップグレード';
  String get premiumMember => _isEn ? 'Premium Member' : 'プレミアム会員';
  String get premiumSubtitle =>
      _isEn ? 'All features are available' : '全機能をご利用いただけます';
  String get restorePurchase => _isEn ? 'Restore Purchase' : '購入を復元';
  String get restorePurchaseDone => _isEn ? 'Purchase restored' : '購入を復元しました';
  String get record => _isEn ? 'Record' : '記録';
  String get history => _isEn ? 'History' : '履歴';
  String get graph => _isEn ? 'Graph' : 'グラフ';
  String get delete => _isEn ? 'Delete' : '削除';
  String get saveAPIKey => _isEn ? 'Save API Key' : 'APIキーを保存';
  String get notifyToWriteJournal =>
      _isEn ? 'Notify you to write your journal' : '日記を書くよう通知する';
  String get testData365DaysAdded =>
      _isEn ? 'Added 365 days of test data' : '365日分のテストデータを追加しました';
  String get testData365DaysButton =>
      _isEn ? '🧪 Add 365 days test data' : '🧪 テストデータ365日追加';
  String get loading => _isEn ? 'Loading...' : '読み込み中...';
  String get error => _isEn ? 'Error' : 'エラー';
  String get errorOccurred => _isEn ? 'An error occurred' : 'エラーが発生しました';

  // 記録画面
  String get recordTitle => _isEn ? "Today's Record" : '今日の記録';
  String get alreadySavedTitle =>
      _isEn ? 'Already recorded today' : '今日は記録済みです';
  String get alreadySavedSubtitle =>
      _isEn ? 'See you tomorrow 😊' : 'また明日記録しましょう 😊';
  String get timerLabel => _isEn ? '1-min Timer' : '1分タイマー';
  String get timerUsedLabel =>
      _isEn ? '1-min Timer (used today)' : '1分タイマー（本日使用済み）';
  String timerSeconds(int s) => _isEn ? '${s}s' : '$s秒';
  String get diaryLabel => _isEn ? "Today's Journal" : '今日の日記';
  String get diaryHint => _isEn ? 'How was your day?' : '今日はどんな一日でしたか？';
  String get diaryHintTimerEnd => _isEn ? "Time's up" : '時間になりました';
  String get diaryHintTimerOff =>
      _isEn ? 'Turn on the timer to write' : '1分タイマーをONにして書いてください';
  String get saveButton => _isEn ? 'Save' : '保存';
  String get savedButton => _isEn ? 'Saved ✅' : '記録済み ✅';
  String get aiSummaryTitle => _isEn ? 'AI Summary' : 'AI 要約';
  String get aiLockedMessage => _isEn
      ? 'AI summary: 3x/month (free)\nUnlimited with Premium'
      : 'AI要約は月3回まで（無料）\nプレミアムで無制限';
  String get aiNoApiKey => _isEn
      ? 'Set your API key to enable AI summary.'
      : 'APIキーを設定すると要約が表示されます。';

  // 履歴画面
  String get historyTitle => _isEn ? 'History' : '履歴';
  String get historyEmpty => _isEn ? 'No records yet' : 'まだ記録がありません';
  String get historyEmptySubtitle =>
      _isEn ? 'Record your mood from the Record tab' : '記録タブから今日の気持ちを残しましょう';
  String get historyNoText => _isEn ? '(no text)' : '(本文なし)';
  String get historyAiSummary => _isEn ? 'AI Summary' : 'AI要約';
  String get historyError => _isEn ? 'Error' : 'エラー';

  // グラフ画面
  String get statsTitle => _isEn ? 'Graph' : 'グラフ';
  String get statsNoData => _isEn ? 'No data yet' : 'まだデータがありません';
  String get statsAvgScore => _isEn ? 'Overall Average Score' : '全体平均スコア';
  String get statsAvgNote => _isEn
      ? '(Energy/Focus/Mood: higher is better. Fatigue/Sleepiness: lower is better)'
      : '（気力・集中・気分は高め、疲れ・眠気は低めが良いスコアです）';
  String get statsChartTitle => _isEn ? '5-Axis Trend' : '5軸の推移';
  String statsChartLabel(String label) =>
      _isEn ? '5-Axis Trend ($label)' : '5軸の推移（$label）';
  String get statsWeekAvg => _isEn ? 'Weekly Avg' : '週平均';
  String get statsMonthAvg => _isEn ? 'Monthly Avg' : '月平均';
  String get statsDayly => _isEn ? 'Daily' : '日別';
  String get statsAiButton =>
      _isEn ? 'Analyze this period with AI' : 'この期間をAIで分析';
  String get statsAiLoading => _isEn ? 'Analyzing...' : '分析中...';
  String get statsAiLocked =>
      _isEn ? 'AI analysis (monthly limit reached)' : 'AI分析（今月の上限に達しました）';
  String get statsPeriodAll => _isEn ? 'All' : '全期間';

  // タブバー
  String get tabRecord => _isEn ? 'Record' : '記録';
  String get tabHistory => _isEn ? 'History' : '履歴';
  String get tabStats => _isEn ? 'Graph' : 'グラフ';
  String get tabSettings => _isEn ? 'Settings' : '設定';

  // 設定画面
  String get settingsTitle => _isEn ? 'Settings' : '設定';
  String get settingsApiKey => _isEn ? 'Claude API Key' : 'Claude API キー';
  String get settingsApiKeySave => _isEn ? 'Save API Key' : 'APIキーを保存';
  String get settingsApiKeyDelete => _isEn ? 'Delete' : '削除';
  String get settingsApiKeySaved => _isEn ? 'API key saved' : 'APIキーを保存しました';
  String get settingsApiKeyDeleted =>
      _isEn ? 'API key deleted' : 'APIキーを削除しました';
  String get settingsApiKeyEmpty =>
      _isEn ? 'Please enter an API key' : 'APIキーを入力してください';
  String get settingsLanguage => _isEn ? 'Language' : '言語';
  String get settingsNotifications => _isEn ? 'Notifications' : '通知';
  String get settingsReminderTitle => _isEn ? 'Daily Reminder' : '毎日リマインダー';
  String get settingsReminderSubtitle =>
      _isEn ? 'Notify you to write your journal' : '日記を書くよう通知する';

  // 軸ラベル（履歴・グラフ共通）
  List<String> get axisLabelsShort => _isEn
      ? ['Energy', 'Focus', 'Fatigue', 'Mood', 'Sleep']
      : ['気力', '集中', '疲れ', '気分', '眠気'];

  List<String> get axisLabels => _isEn
      ? ['Energy ⚡', 'Focus 🎯', 'Fatigue 😴', 'Mood 😊', 'Sleepiness 🌙']
      : ['気力 ⚡', '集中 🎯', '疲れ 😴', '気分 😊', '眠気 🌙'];
}
