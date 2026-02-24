# Pulse 開発メモ

- **テストデータ**: 設定画面の開発用から「テストデータ投入（約120日分）」で投入。今日を含む120日分、1日1レコード。永続化3項目（気力・集中・疲れ）で生成。気分・眠気はDB未対応のため2枚目では「データがありません」表示。
- **観測画面（2枚目）**: 5項目グラフを縦並び（small multiples）で表示。1本の合成グラフではなく、項目ごとに小さな折れ線を並べる。7/14/30切替で5項目すべて更新。
- **起動**: Pulse 作業時は `workspace/pulse.code-workspace` を開き、`apps/pulse_app` で `flutter run` すること。他リポジトリ（例: boundary_app）を開いたまま実行すると編集と実行の対象がずれる。
- **packages**: Pulse は `packages/core_state` に依存。日付正規化・DailyStateEntry・Repository は共通。
