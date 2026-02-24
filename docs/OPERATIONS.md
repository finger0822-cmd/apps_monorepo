# 運用ルール（マルチアプリ開発）

## A. 標準起動ルール（重要）

- **Pulse の日常開発**: **`workspace/pulse.code-workspace`** を開いてから作業を始める（File → Open Workspace from File）。
- **起動手順**: Cursor/VSCode で `apps_monorepo/workspace/pulse.code-workspace` を開く → ターミナルで `cd apps/pulse_app && flutter run -d <デバイスID>`（またはモノレポ内の run_pulse.sh 相当を実行）。
- **目的**: 文脈を Pulse に固定し、他アプリ・モノレポ全体を開いての脱線を防ぐ。
- **注意**: Pulse を編集するときは、必ず pulse.code-workspace を開いた上で `apps/pulse_app` をルートに実行すること。別フォルダ（例: boundary_app）を開いたまま実行すると、編集対象と実行対象が一致しない。

## B. all_apps の使い方

- **all_apps.code-workspace** は **横断作業専用**（共通化・設計整理・packages 整理・リネームなど）。
- **常時開きっぱなしにしない**。使う時間帯や目的（例: 週次の設計整理）を決めておくとよい。
- 日常の実装は **pulse / after / boundary の各 workspace** で行う。

## C. docs 運用ルール

- 仕様・画面役割・項目定義は **各アプリの `docs/<app>/`** に置く（例: `docs/pulse/`）。
- **Pulse** の仕様変更時は、**`docs/pulse/` を先に（または実装と同時に）更新**する。
- 共通仕様が出てきたら **`docs/common/`** を設けてよい。アプリ固有の仕様は共通 docs に混ぜない。

## D. 共通化判断ルール（実用）

- **2回似ているだけでは共通化しない**。**3回以上** かつ **意味が同じ** なら共通化を検討する。
- Pulse 固有の観測UI・文言・統計表現は **当面アプリ内に保持**する。packages 化は「他アプリでも同じ意味で使う」ことがはっきりしてからでよい。
