# Next/Insight 画面 WaveHeader ラベル重なり修正プラン

## 1. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| `lib/ui/next_screen.dart` | body の _RhythmBlock を固定高さ WaveHeader に置き換え、余白追加 |
| `lib/ui/widgets/wave_header.dart` | Next用の Stack レイアウト対応（任意パラメータ追加） |

**方針**: Next 画面では `WaveHeader` を流用し、`fixedHeight` 指定時に Stack レイアウトを使う。

---

## 2. Before / After Widget ツリー

### Before（Next/Insight 画面 body）

```
Scaffold
└── SafeArea
    └── SingleChildScrollView (padding: 24h, 20v)
        └── Column (mainAxisSize: min)
            ├── SizedBox(height: 16)
            ├── _RhythmBlock          ← 高さ未固定、min に依存
            │   └── Column
            │       ├── Center > SizedBox > SparklineWave (72px)
            │       ├── SizedBox(height: 12)
            │       └── Center > Text (ラベル)
            ├── SizedBox(height: 24)
            ├── _TodayBlock (体力/集中/疲れ 1〜5)
            ├── SizedBox(height: 40)
            └── _HistoryBlock
```

**問題**: `_RhythmBlock` が `mainAxisSize.min` の Column の一部。ラベルと _TodayBlock の間が 24px しかなく、フォント拡大や端末差で重なる可能性がある。

### After

```
Scaffold
└── SafeArea
    └── SingleChildScrollView (padding: 24h, 20v)
        └── Column (mainAxisSize: min)
            ├── SizedBox(height: 104)   ← 固定高さヘッダー領域
            │   └── WaveHeader (entries, rhythmResult)
            │       └── Stack
            │           ├── Align(topCenter) > SparklineWave
            │           └── Positioned(right: 16, bottom: 8) > Text
            ├── SizedBox(height: 28)    ← 固定余白（24→28）
            ├── _TodayBlock
            ├── SizedBox(height: 40)
            └── _HistoryBlock
```

**解消**: WaveHeader を 104px の SizedBox で囲み、内部で Stack によりラベルを右下に固定。その下に必ず 28px 余白を入れて、入力UIとの重なりを防ぐ。

---

## 3. 差分の要点

| 項目 | Before | After |
|------|--------|-------|
| ヘッダー | _RhythmBlock（高さ未固定） | SizedBox(104) + WaveHeader |
| ヘッダー内部 | Column（折れ線 → ラベル） | Stack（折れ線上寄せ、ラベル Positioned） |
| ヘッダー直後余白 | 24px | 28px |
| ラベル位置 | Column 内の次の行 | Positioned(right: 16, bottom: 8) |
| 全体レイアウト | Column（既存） | Column のまま、Stack はヘッダー内のみ |

---

## 4. WaveHeader の Stack 対応（案）

`WaveHeader` にオプションを追加し、Next 用レイアウトを切り替える。

```dart
WaveHeader({
  this.entries,
  this.rhythmResult,
  this.useFixedHeightLayout = false,  // true: Stack + Positioned
});
```

- `useFixedHeightLayout: false`（Today 用）: 既存の Column + Align レイアウト
- `useFixedHeightLayout: true`（Next 用）: SizedBox 親を前提に Stack で折れ線上寄せ、ラベル `Positioned(right: 16, bottom: 8)`

Next 画面では `SizedBox(height: 104, child: WaveHeader(..., useFixedHeightLayout: true))` を渡す。

---

## 5. 端末サイズ差の確認観点

| 端末 | 確認内容 |
|------|----------|
| iPhone SE (375×667) | 104px ヘッダー + 28px 余白で体力セクションと十分離れているか |
| iPhone 14/15 (390×844) | 同様に重なりがないか |
| iPhone 14/15 Pro Max (430×932) | ラベルが右下で切れないか |
| アクセシビリティ | テキスト拡大時（Dynamic Type）でも重ならないか |
| 縦向き | SafeArea 込みでヘッダー高さが適切か |

---

## 6. 追加提案：Next 画面の役割整理

**現状**: Next/Insight 画面 = 波 + 体力/集中/疲れ（読み取り） + 履歴チャート

**提案**: Next 画面を「意味（Insight）」に絞る場合
- 体力/集中/疲れの入力UI（_TodayBlock）を削除
- 波 + Insight テキストのみにする
- 履歴チャート（_HistoryBlock）は残すか、波に統合するか検討

この場合、入力UI との重なりは発生しなくなるが、ユーザーが今日の値を見直したいニーズは別途検討が必要。
