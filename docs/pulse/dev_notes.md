# Pulse 開発メモ

- **テストデータ**: 設定画面の開発用から「テストデータ投入（約120日分）」で投入。今日を含む120日分、1日1レコード。永続化3項目（気力・集中・疲れ）で生成。気分・眠気はDB未対応のため2枚目では「データがありません」表示。
- **観測画面（2枚目）**: 5項目グラフを縦並び（small multiples）で表示。1本の合成グラフではなく、項目ごとに小さな折れ線を並べる。7/14/30切替で5項目すべて更新。
- **起動**: Pulse 作業時は `workspace/pulse.code-workspace` を開き、`apps/pulse_app` で `flutter run` すること。他リポジトリ（例: boundary_app）を開いたまま実行すると編集と実行の対象がずれる。
- **packages**: Pulse は `packages/core_state` に依存。日付正規化・DailyStateEntry・Repository は共通。

## iOS 実機で起動する手順

- **StoreKit デバッグ**: iOS の StoreKit デバッグ（`logEntitlementsForDebug`）はシミュレータ専用です。実機では呼ばれないため、IAP 未設定の実機でも起動に影響しません。
- **Signing（Team）**: 実機で別の Apple Developer Team を使う場合は、Xcode で `ios/Runner.xcworkspace` を開き、Signing & Capabilities で Team を選択してください。

1. **通常の起動**

   クリーン後や初回クローン後は、次の順で実行することを推奨します。
   ```bash
   cd apps/pulse_app
   flutter pub get
   cd ios && pod install && cd ..
   flutter run -d <実機のデバイスID>
   ```
   通常時のみ起動する場合:
   ```bash
   cd apps/pulse_app
   flutter pub get
   flutter run -d <実機のデバイスID>
   ```
   または実機用スクリプト（codesign 失敗時に対処コマンドを表示）:
   ```bash
   cd apps/pulse_app
   ./run_ios_device.sh <実機のデバイスID>
   ```

2. **codesign エラー（「resource fork, Finder information, or similar detritus not allowed」）が出る場合**  
   macOS Sequoia 以降で、実機用の `Flutter.framework` や `build/native_assets/ios/` に拡張属性が付いて失敗することがあります。detritus 系のエラーは下記で対応してください。

   **対処A: build 配下の xattr 削除してから再実行**
   - 1回目: `flutter run -d <ID>` または `./run_ios_device.sh <ID>` を実行（codesign で失敗する場合あり）
   - 失敗後、**同じターミナルで** 以下を実行:
     ```bash
     xattr -cr build
     ```
   - もう一度:
     ```bash
     flutter run -d <実機のデバイスID>
     ```
   - `run_ios_device.sh` を使っている場合は、スクリプトが自動で上記を試行します。

   **対処A': Flutter.framework のみエラーの場合（従来）**
   - 1回目: `flutter run -d <ID>` を実行（codesign で失敗する想定）
   - 失敗後、**同じターミナルで** 以下を実行（パスワード入力が必要）:
     ```bash
     sudo xattr -cr build/ios/Debug-iphoneos/Flutter.framework
     ```
   - **flutter clean はせずに** もう一度:
     ```bash
     flutter run -d <実機のデバイスID>
     ```

   **対処B: Xcode から実行**
   - `apps/pulse_app/ios/Runner.xcworkspace` を Xcode で開く
   - Product → Clean Build Folder のあと、実機を選んで Run

   **対処C: native_assets (objective_c.framework) で繰り返し失敗する場合**
   - `build/native_assets/ios/` に拡張属性が付いたまま codesign される現象が発生することがあります。
   - ターミナルで `xattr -cr build` を実行した直後に、**Xcode から** Product → Run で実機実行すると通る場合があります（`flutter run` だと再ビルドで再び xattr が付くため）。

3. **参考**: [Flutter issue #181103](https://github.com/flutter/flutter/issues/181103)

## Flutter SDK パッチ（macOS Sequoia native_assets codesign）

macOS Sequoia で `build/native_assets/ios/*.framework` に付与される拡張属性により `Target install_code_assets failed` が発生する問題を避けるため、Flutter SDK に以下のパッチを適用している場合があります。

- **xcode_backend.sh**: `$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh` で、Dart 呼び出し前に `build/native_assets` と `BUILT_PRODUCTS_DIR` に対して `xattr -cr` を実行。
- **native_assets_host.dart**: `$FLUTTER_ROOT/packages/flutter_tools/lib/src/isolated/native_assets/macos/native_assets_host.dart` の `codesignDylib` 内で、`codesign` 実行直前に対象パスに対して `xattr -cr` を実行。

**Flutter upgrade 後の再適用**: `flutter upgrade` 後に上記エラーが再発した場合は、同じ2ファイルに上記の xattr 削除処理を再度追加してください。手順はリポジトリ内の本節または担当者に確認。
