#!/bin/sh
# Flutter build を実行。PhaseScriptExecution 失敗（install_code_assets detritus 等）対策として
# 各ビルド前に build / native_assets / Flutter cache の xattr を削除し、失敗時は最大2回までリトライする。

# Xcode からビルド時も FLUTTER_ROOT を確実に取得する
if [ -z "${FLUTTER_ROOT}" ] && [ -f "${PROJECT_DIR}/Flutter/Generated.xcconfig" ]; then
  export FLUTTER_ROOT=$(grep -E '^FLUTTER_ROOT=' "${PROJECT_DIR}/Flutter/Generated.xcconfig" | cut -d= -f2-)
fi

BUILD_ROOT="${PROJECT_DIR}/../build"
export COPYFILE_DISABLE=1

_strip_xattr() {
  if [ -d "$BUILD_ROOT" ]; then
    xattr -cr "$BUILD_ROOT" 2>/dev/null || true
  fi
  if [ -n "${FLUTTER_ROOT}" ] && [ -d "${FLUTTER_ROOT}/bin/cache" ]; then
    xattr -cr "${FLUTTER_ROOT}/bin/cache" 2>/dev/null || true
  fi
  PODS_ROOT="${PROJECT_DIR}/Pods"
  if [ -d "$PODS_ROOT" ]; then
    xattr -cr "$PODS_ROOT" 2>/dev/null || true
  fi
}

_do_build() {
  _strip_xattr
  COPYFILE_DISABLE=1 /bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
}

_do_build
EXIT=$?
if [ "$EXIT" -ne 0 ]; then
  _strip_xattr
  _do_build
  EXIT=$?
fi
if [ "$EXIT" -ne 0 ]; then
  _strip_xattr
  _do_build
  EXIT=$?
fi
exit "${EXIT}"
