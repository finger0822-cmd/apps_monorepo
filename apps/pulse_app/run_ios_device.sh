#!/usr/bin/env bash
# Pulse を iOS 実機で起動するスクリプト。
# codesign (detritus) エラー時は sudo xattr -cr を実行してから自動で再試行します。
#
# 使い方:
#   ./run_ios_device.sh [デバイスID]     … デバッグモードで起動（VM Service 接続を待つ）
#   ./run_ios_device.sh --release [ID]    … リリースモードで起動（接続待ちなしで確実に起動）

DEVICE_ID=""
RELEASE=""
for arg in "$@"; do
  case "$arg" in
    --release|-r) RELEASE=1 ;;
    *)            [ -z "$DEVICE_ID" ] && DEVICE_ID="$arg"
  esac
done
[ -z "$DEVICE_ID" ] && DEVICE_ID="00008110-001970381E38801E"

BUILD_DIR="build/ios/Debug-iphoneos"
[ -n "$RELEASE" ] && BUILD_DIR="build/ios/Release-iphoneos"

# コピー時に拡張属性を付けないよう環境変数を設定（macOS Sequoia+ の codesign 対策）
export COPYFILE_DISABLE=1

# 既存の build に xattr が残っていると CodeSign が失敗するため、事前に削除
if [ -d "build" ]; then
  xattr -cr "$(pwd)/build" 2>/dev/null || true
fi

run_build() {
  if [ -n "$RELEASE" ]; then
    flutter run -d "$DEVICE_ID" --release
  else
    flutter run -d "$DEVICE_ID"
  fi
}

run_build && exit 0
EXIT=$?

# CodeSign / detritus 系エラーなら build 配下の xattr を削除して1回だけ再試行
if [ $EXIT -ne 0 ]; then
  if [ -d "build" ]; then
    echo ""
    echo "=============================================="
    echo "  codesign エラー検出 → 拡張属性を削除して再試行します"
    echo "=============================================="
    xattr -cr "$(pwd)/build" 2>/dev/null || true
    echo "再ビルドを実行します..."
    if run_build; then
      exit 0
    fi
  fi
fi

exit $EXIT
