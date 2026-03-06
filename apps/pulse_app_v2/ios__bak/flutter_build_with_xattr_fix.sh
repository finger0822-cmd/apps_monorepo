#!/usr/bin/env bash
# Workaround for macOS Sequoia+ codesign: "resource fork, Finder information, or similar detritus not allowed"
# Run build; if it fails, strip xattr + codesign on Flutter.framework and retry once.

set -e
FLUTTER_SCRIPT="${FLUTTER_ROOT}/packages/flutter_tools/bin/xcode_backend.sh"
if [ ! -f "$FLUTTER_SCRIPT" ]; then
  echo "error: Flutter script not found at $FLUTTER_SCRIPT" >&2
  exit 1
fi

FW_DIR="${BUILT_PRODUCTS_DIR:-${PROJECT_DIR}/../build/ios/${CONFIGURATION}-iphoneos}/Flutter.framework"
FLUTTER_BIN="${FW_DIR}/Flutter"

do_build() {
  "/bin/sh" "$FLUTTER_SCRIPT" build
}

apply_workaround() {
  if [ -f "$FLUTTER_BIN" ] && [ -n "${EXPANDED_CODE_SIGN_IDENTITY:-}" ]; then
    echo "Applying xattr + codesign workaround for Flutter.framework..." >&2
    xattr -cr "$FW_DIR" 2>/dev/null || true
    codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" --timestamp=none "$FLUTTER_BIN" 2>/dev/null || true
  fi
}

if do_build; then
  exit 0
fi
# First run failed; apply workaround and retry once
apply_workaround
do_build
