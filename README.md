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

## Support / Privacy Pages

`docs/` 配下にアプリ別のサポートページを配置しています。

- `docs/boundary/`
- `docs/one-minute-diary/`

共通スタイルは `docs/assets/styles.css` を使用しています。

### GitHub Pages 設定手順

1. GitHub リポジトリの `Settings` → `Pages` を開く
2. `Deploy from a branch` を選択
3. `Branch: main` / `Folder: /docs` を選択
4. `Save` を押す

### 公開URL例

- Boundary: `https://YOUR_GITHUB_USERNAME.github.io/YOUR_REPO/boundary/`
- 1分日記: `https://YOUR_GITHUB_USERNAME.github.io/YOUR_REPO/one-minute-diary/`
