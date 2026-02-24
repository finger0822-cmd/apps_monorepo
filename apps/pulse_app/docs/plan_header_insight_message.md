# WaveHeader「AIの一言（観測の解釈）」追加プラン

## 1. 追加ファイルと責務

| ファイル | 責務 |
|----------|------|
| `lib/domain/insights/header_insight_builder.dart` | 直近 entries と waveScore から **1行の観測解釈文** を生成。命令/医療/断定を出さない。 |

**入出力**

- **入力**: `List<DailyStateEntry> entries`（直近7〜14日想定）、waveScore は既存 `waveScoreFor(e)` で算出して渡すか、builder 内で利用
- **出力**: `HeaderInsightResult`（例: `message: String`, `tag: String?`）
  - `message`: 短い観測文（1行、最大2行で表示する想定）
  - `tag`: 任意（例: 「安定」「上向き」「下向き」）。表示しなくても可

**既存との関係**

- `lib/domain/insights/insight_generator.dart`: 長文インサイト用。Header 用は **別** に `header_insight_builder` を用意し、**短文・観測のみ・回復期ガイドライン** に特化させる。

---

## 2. InsightMessage 生成ロジック（条件分岐と優先順位）

### 前提

- `entries.length < 3` → メッセージは返さない（空文字 or null）。UI では非表示。
- `entries.length >= 7` で最も自然にメッセージが出る。

### ロジック順（最小で効く順）

1. **直近の傾向（上向き/下向き/安定）**
   - 直近3日の waveScore 平均 vs その前3日の waveScore 平均の差分を計算。
   - 閾値（例: ±0.15 や ±0.2）で「上向き」「下向き」「安定」を判定。
   - **出力例**: 「ここ数日は少し上向きの傾向かもしれません」「おおむね安定した波のようです」

2. **振れ幅（補助）**
   - 直近7日の waveScore の `max - min` で振れ幅を算出。
   - 小/中/大を閾値で分け、1 で出した傾向に **続けて** 出すか、傾向が無いときだけ出す。
   - **出力例**: 「波の振れは小さめです」「振れ幅がやや大きい一週間かもしれません」

3. **相関（任意・余裕があれば）**
   - 体力と疲れの相関が高ければ「疲れと連動しやすい傾向」など。
   - 既存 `time_series_stats` の相関を流用可能。

### 優先順位（メッセージは1本にまとめる想定）

1. **まず傾向**: 安定 / 上向き / 下向き のいずれかを1文で。
2. **次に振れ幅**: 傾向文のあとに「振れは小さめ」などを足すか、傾向が無いときだけ振れ幅1文にする。
3. **相関**: 余裕があれば「〜と連動しやすい傾向」を追加。

### 条件分岐イメージ（疑似コード）

```
if (entries.length < 3) return null;

scores = entries.take(7).map(waveScoreFor).toList();
recent3 = scores.last(3).average();
prev3   = scores.sublist(-6, -3).average();
diff    = recent3 - prev3;

if (diff > 0.2)  → "ここ数日は少し上向きの傾向かもしれません"
if (diff < -0.2) → "ここ数日は少し下向きの傾向かもしれません"
else             → "おおむね安定した波のようです"

span = scores.max - scores.min;
if (span < 0.3 && 傾向が安定) → 追記 "振れは小さめです"
if (span > 0.6) → 追記 or 単独 "振れ幅がやや大きい一週間かもしれません"
```

---

## 3. UI 差分（_WaveHeaderSection の変更点）

### 現在（2段）

```
Column(mainAxisAlignment: center)
├── SparklineWave
├── SizedBox(8)
└── Text(RhythmLabel)  // 今日のリズム：N日 or ゆるやか
```

### 変更後（3段）

```
Column(mainAxisAlignment: center)
├── SparklineWave
├── SizedBox(6)
├── InsightMessage（NEW）
│   - textAlign: TextAlign.center
│   - maxLines: 2
│   - overflow: TextOverflow.ellipsis（または fade）
│   - fontSize: 14〜16（RhythmLabel より少し大きく）
│   - 主張しすぎない色/opacity（例: _labelColor, opacity 0.9）
├── SizedBox(4)
└── Text(RhythmLabel)  // 既存
```

### 表示条件

- `entries.length < 3`: InsightMessage は表示しない（空欄）。波＋RhythmLabel のみ、または「今日のリズム：ゆるやか」のみでも可。
- `message.isEmpty`: InsightMessage の Widget は非表示（SizedBox.shrink() など）。

### レイアウト調整

- 高さ 120 のまま収まらない場合は、Sparkline 高さ 56 → 48 に縮小するか、ヘッダー高さを 130〜140 に微増するか検討（最小変更なら 120 内に収める）。

---

## 4. 文言ガイドライン（禁止/推奨）

### 禁止

- **アドバイス・命令**: 「〜しよう」「〜してください」「〜すべき」「〜してみて」
- **医療・診断**: 「診断」「治療」「症状」「改善」「悪化」「回復」などの医療用語
- **断定**: 「〜です」（観測は「〜のようです」「〜かもしれません」に寄せる）
- **ネガティブの強調**: 「悪い」「ダメ」など

### 推奨

- **推定・傾向**: 「〜の傾向かもしれません」「〜しやすいようです」「おおむね〜」
- **観測の事実**: 「ここ数日は〜」「波の振れは〜」「〜と連動しやすい傾向」
- **トーン**: 天気予報・観測レポート。命令しない・回復期に安全な一言。

### 例（OK / NG）

| OK | NG |
|----|-----|
| ここ数日は少し上向きの傾向かもしれません | 調子が良くなっています |
| おおむね安定した波のようです | 安定しています |
| 波の振れは小さめです | 振れが小さいので安心してください |
| 疲れと連動しやすい傾向があります | 疲れを減らすと良いです |

---

## 5. 最小 PR 構成

| 順序 | 内容 |
|------|------|
| 1 | **ドメイン**: `lib/domain/insights/header_insight_builder.dart` を新規追加。`HeaderInsightResult`, `buildHeaderInsight(entries)` を実装。waveScore は builder 内で `waveScoreFor` を参照するため、`core_state` に依存し、`sparkline_wave` の関数を domain から使うか、同じ計算を domain にコピーするか検討。※ `waveScoreFor` が UI 層にある場合は、domain に `waveScoreForEntry(DailyStateEntry)` を置くか、builder の引数で `List<double> waveScores` を渡す形にする。 |
| 2 | **UI**: `next_screen.dart` の `_WaveHeaderSection` で、`buildHeaderInsight(_entries ?? [])` を呼び、`message` があれば 3 段目に `Text(message, ...)` を挿入。entries.length < 3 のときは message を表示しない。 |
| 3 | **ドキュメント**: `docs/next_insight_redesign_ux.md` に追記。「WaveHeader が波＋解釈＋ラベルの 3 層になったこと」「命令しない観測文にした理由」「文言ガイドライン」の要約。 |

### 依存の整理

- `waveScoreFor` が `lib/ui/widgets/sparkline_wave.dart` にあるため、**domain から UI を参照しない**ようにするには、
  - **案A**: `header_insight_builder` の引数に `List<double> waveScores` を渡し、呼び出し元（next_screen）で `entries.map(waveScoreFor).toList()` を計算して渡す。
  - **案B**: `lib/domain/insights/` に `wave_score.dart` を新規作成し、`double waveScoreForEntry(DailyStateEntry e)` を定義。`sparkline_wave.dart` はそこを import して使う。
- 最小 PR では **案A** が変更少なく済む。
