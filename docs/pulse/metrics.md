# Pulse 項目定義（案A）

全画面・全ロジックで共通参照。直書き禁止。実装は `lib/domain/metrics/pulse_metric.dart` の `PulseMetric.all` を参照すること。

## 5項目一覧

| order | id | 表示名 | 左ラベル | 右ラベル |
|-------|-----|--------|----------|----------|
| 1 | energy | 気力 | わかない | わく |
| 2 | focus | 集中 | 散る | 集中 |
| 3 | fatigue | 疲れ | 少 | 多 |
| 4 | mood | 気分 | 重い | 軽い |
| 5 | sleepiness | 眠気 | 少 | 強い |

## 長押し説明（1枚目）

各項目で共通定義に含めるもの:

- id / 表示名 / 左ラベル / 右ラベル
- 説明本文（descriptionBody）
- 低い値の目安（lowGuide）
- 高い値の目安（highGuide）
- 表示順（order）

永続化は現時点で energy, focus, fatigue の3項目（persistedIds）。
