# Feature 追加テンプレ

新 feature を追加するときはこのディレクトリをコピーして使う。

## 3 手順

1. **コピー**: `_template/` をコピーし、`lib/features/<feature_name>/` にリネームする（`<feature_name>` は snake_case）。
2. **置換**: 各ファイル内の `feature` / `Feature` / `_template` 等のプレースホルダを `<feature_name>` に置換する（クラス名・ファイル名・import パス）。
3. **配線**: 実装を追加し、main またはルートで当 feature の画面・Provider を配線する。

## 命名規則

- feature 名: **snake_case**（例: `pulse`, `subscription`）。
- Provider: **application/providers** にのみ定義する。domain 層には Riverpod を import しない。
- Repository interface: **domain/repositories/**（例: `xxx_repository.dart`）。
- Repository 実装: **data/repositories/**（例: `xxx_repository_impl.dart`）。
- UseCase: **domain/usecases/**、メソッドは `execute()` を基本とする。

## 依存方向

- presentation → application（Provider）→ domain（UseCase / interface）
- domain → なし（純 Dart）
- data → domain（entity / interface）

presentation が data を直接 import しないこと。
