#!/bin/sh
# macOS Sequoia+ codesign 対策: Runner.app の拡張属性を削除する（CodeSign 失敗を防ぐ）
# Run Script から呼ばれ、BUILT_PRODUCTS_DIR と Flutter の build/ios をクリアする

XATTR="/usr/bin/xattr"
[ -x "$XATTR" ] || XATTR="xattr"

if [ -n "$BUILT_PRODUCTS_DIR" ] && [ -d "$BUILT_PRODUCTS_DIR" ]; then
  "$XATTR" -cr "$BUILT_PRODUCTS_DIR" 2>/dev/null || true
fi
# Flutter は build/ios/CONFIGURATION-iphoneos に Runner.app を出力する
CONF="${CONFIGURATION:-Debug}"
if [ -n "${PROJECT_DIR:-}" ]; then
  FLUTTER_APP_DIR="${PROJECT_DIR}/../build/ios/${CONF}-iphoneos"
  if [ -d "$FLUTTER_APP_DIR" ]; then
    "$XATTR" -cr "$FLUTTER_APP_DIR" 2>/dev/null || true
  fi
  # build/ios 全体も strip（別構成の残り対策）
  FLUTTER_IO="${PROJECT_DIR}/../build/ios"
  if [ -d "$FLUTTER_IO" ]; then
    "$XATTR" -cr "$FLUTTER_IO" 2>/dev/null || true
  fi
fi
