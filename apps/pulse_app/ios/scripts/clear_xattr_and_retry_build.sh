#!/bin/sh
# Flutter build を実行。PhaseScriptExecution 失敗（install_code_assets detritus 等）対策として
# 各ビルド前に build 配下の xattr を削除し、失敗時は最大2回までリトライする。

BUILD_ROOT="${PROJECT_DIR}/../build"
export COPYFILE_DISABLE=1

_do_build() {
  if [ -d "$BUILD_ROOT" ]; then
    xattr -cr "$BUILD_ROOT" 2>/dev/null || true
  fi
  COPYFILE_DISABLE=1 /bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
}

_do_build
EXIT=$?
if [ "$EXIT" -ne 0 ]; then
  _do_build
  EXIT=$?
fi
if [ "$EXIT" -ne 0 ]; then
  _do_build
  EXIT=$?
fi
exit "${EXIT}"
