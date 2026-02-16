# apps_monorepo

複数のFlutterアプリを1つのリポジトリで管理するモノレポです。

## 構成

- `apps/` : 各アプリ本体
- `packages/` : 将来の共通パッケージ置き場（現在は空）
- `docs/` : ドキュメント/GitHub Pages用（現在は空）

## 取り込み済みアプリ

- `apps/after_app`（Flutter構成チェックでは不足あり）
- `apps/particle_app`
- `apps/boundary_app`
- `apps/one_sentence_app`
- `apps/snow_blackhole`
- `apps/one_minute_diary_app`
- `apps/one_minute_diary`

## 起動方法

```bash
cd apps/<app_name>
flutter pub get
flutter run
```

例:

```bash
cd apps/one_minute_diary
flutter pub get
flutter run
```

## 運用方針

- 元フォルダは `~/Desktop` に残し、`apps/` へコピーで統合
- 各アプリは独立して実行可能な状態を維持
- ネストした `.git` は削除し、ルートGitで一元管理
