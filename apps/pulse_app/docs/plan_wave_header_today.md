# Today画面 折れ線グラフヘッダー化 プラン

## 1. 追加ファイル一覧

| ファイル | 内容 |
|----------|------|
| `lib/ui/widgets/wave_header.dart` | `WaveHeader` StatelessWidget（新規） |

**依存関係:**
- `wave_header.dart` → `sparkline_wave.dart`（既存）、`core_state.dart`、`rhythm_detector.dart`

---

## 2. TodayLogScreen 変更差分

### 2.1 import 追加

```dart
import 'widgets/wave_header.dart';
```

### 2.2 データ取得

`TodayLogScreen` は現状エントリを取得していない。`WaveHeader` 表示のため、以下のいずれかが必要：

- **案A**: `initState` で `deps.repo.latest(7)` を取得し、`State` に `entries` を保持
- **案B**: `WaveHeader` に `deps` を渡し、内部で FutureBuilder により非同期取得

推奨は **案A**（親で取得して子に渡す方が責務が明確）。

### 2.3 body 変更

**Before:**

```dart
body: Column(
  children: [
    const Spacer(flex: 3),
    Center(
      child: SizedBox(
        width: _rowWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MetricRow(label: energy, ...),
            _MetricRow(label: focus, ...),
            _MetricRow(label: fatigue, ...),
            // 次へボタン
          ],
        ),
      ),
    ),
    const Spacer(),
  ],
)
```

**After:**

```dart
body: SafeArea(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      WaveHeader(entries: _entries, rhythmResult: _rhythmResult),
      const SizedBox(height: 24),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: _rowWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MetricRow(label: energy, ...),
                      SizedBox(height: _sectionSpacing),
                      _MetricRow(label: focus, ...),
                      SizedBox(height: _sectionSpacing),
                      _MetricRow(label: fatigue, ...),
                      SizedBox(height: 28),
                      Align(alignment: Alignment.centerRight, child: 次へボタン),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)
```

※ `_MetricRow` はそのまま利用し、`EnergySection` / `FocusSection` / `FatigueSection` として包むか、同一コンポーネントとして扱う。

---

## 3. Widget ツリー Before / After

### Before

```
Scaffold
└── Column
    ├── Spacer(flex: 3)
    ├── Center
    │   └── SizedBox(width: _rowWidth)
    │       └── Column
    │           ├── _MetricRow (energy)
    │           ├── _MetricRow (focus)
    │           ├── _MetricRow (fatigue)
    │           └── 次へ ボタン
    └── Spacer
```

※ 折れ線グラフは Today 画面には未存在。

### After

```
Scaffold
└── SafeArea
    └── Column (crossAxisAlignment: start)
        ├── WaveHeader
        │   ├── Padding(horizontal: 16)
        │   │   └── Column (crossAxisAlignment: start)
        │   │       ├── SparklineWave (height: 56)
        │   │       └── Text (ラベル)
        │   └── (entries 0件の場合は SizedBox.shrink)
        ├── SizedBox(height: 24)
        └── Expanded
            └── SingleChildScrollView
                └── Column
                    └── Center
                        └── SizedBox(width: _rowWidth)
                            └── Column
                                ├── _MetricRow (energy)
                                ├── _MetricRow (focus)
                                ├── _MetricRow (fatigue)
                                └── 次へ ボタン
```

---

## 4. 被りが発生しない理由

1. **Column の直列配置**  
   `WaveHeader` → `SizedBox` → `Expanded(SingleChildScrollView(...))` の順で縦に並ぶ。  
   Stack / Positioned を使っていないため、Y 方向の重なりは発生しない。

2. **占有領域が明確**  
   - `WaveHeader`: 高さ固定（折れ線 56px + ラベル + padding）、横幅は親幅の 70–80%  
   - その下の `Expanded` が残りの縦スペースを占有  
   - `SingleChildScrollView` 内のコンテンツはその中だけでスクロール

3. **体力セクションとの分離**  
   体力・集中・疲れの入力 UI は `Expanded` 内の `SingleChildScrollView` の中にあり、ヘッダーとは別のレイヤー。  
   「体力見出しと同 Y 座標」に置かないという制約を満たす。

---

## 5. WaveHeader 仕様（再掲）

| 項目 | 値 |
|------|-----|
| 折れ線高さ | 48〜64px（例: 56） |
| 配置 | 左寄せ |
| 横幅 | 画面幅の 70〜80% |
| 線の opacity | 0.6 程度 |
| 線 | 軸・数値・グリッドなし |
| Padding | 水平 16 |
| ラベル | 折れ線直下、fontSize 12〜14、控えめな色 |

---

## 6. iPhone SE 〜 Pro Max 確認ポイント

| デバイス | 確認内容 |
|----------|----------|
| iPhone SE (3rd) | 幅 375px。WaveHeader 70% ≒ 262px。ラベルが折り返さず 1 行に収まること。 |
| iPhone 14/15 | 幅 390px。通常幅で問題ないこと。 |
| iPhone 14/15 Pro Max | 幅 430px。折れ線が短くなりすぎず、右側の余白が大きくなりすぎないこと。 |

共通:
- SafeArea によりノッチ・ホームインジケータでコンテンツが隠れないこと
- `SingleChildScrollView` により、キーボード表示時やコンテンツが多い場合にスクロールできること
- 折れ線が 2 点未満のときは `SizedBox.shrink` などで高さ 0 にしてレイアウトが崩れないこと
