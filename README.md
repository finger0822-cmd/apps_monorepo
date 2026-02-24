# apps_monorepo

複数のFlutterアプリを1つのリポジトリで管理するモノレポです。

## 構成

- `apps/` : 各アプリ本体
- `packages/` : 共通パッケージ（例: core_state。Pulse が依存）
- `docs/` : ドキュメント・アプリ別仕様（docs/pulse/, docs/boundary/ 等）・GitHub Pages 用
- `workspace/` : アプリ別・横断用の VSCode/Cursor ワークスペース（.code-workspace）
- `tools/` : スクリプト等（任意）

## 取り込み済みアプリ

- `apps/pulse_app`（状態観測。core_state に依存）
- `apps/after_app`（Flutter構成チェックでは不足あり）
- `apps/particle_app`
- `apps/boundary_app`
- `apps/one_sentence_app`
- `apps/snow_blackhole`
- `apps/one_minute_diary_app`
- `apps/one_minute_diary`

## ワークスペース（推奨）

アプリごとに集中するため、**workspace ファイルを開いてから作業**することを推奨します。

- **Pulse の日常開発**: `workspace/pulse.code-workspace` を開く（pulse_app + core_state + docs/pulse のみ。他アプリは含めない）
- **横断作業**（共通化・設計整理）: `workspace/all_apps.code-workspace` を開く。常時起動にはしない
- **運用ルール詳細**: [docs/OPERATIONS.md](docs/OPERATIONS.md) を参照

## 起動方法

```bash
cd apps/<app_name>
flutter pub get
flutter run
```

例（Pulse）:

```bash
cd apps/pulse_app
flutter pub get
flutter run -d <デバイスID>
```

**Pulse を触るとき**: 必ず `workspace/pulse.code-workspace` を開いた上で、`apps/pulse_app` をルートに実行すること。別リポジトリを開いたまま実行すると編集と実行の対象がずれる。

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
