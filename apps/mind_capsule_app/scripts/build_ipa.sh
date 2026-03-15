#!/bin/bash
set -e

# Resolve app root (parent of scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$APP_ROOT"

# Optional: --build-name and --build-number (defaults from pubspec.yaml version if omitted)
# Optional for release: --obfuscate --split-debug-info=build/ios/symbols
# Optional export method: --export-method ad-hoc | app-store | development | enterprise
BUILD_NAME=""
BUILD_NUMBER=""
while [[ $# -gt 0 ]]; do
  case $1 in
    --build-name)
      BUILD_NAME="$2"
      shift 2
      ;;
    --build-number)
      BUILD_NUMBER="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

FLUTTER_ARGS=()
[[ -n "$BUILD_NAME" ]] && FLUTTER_ARGS+=(--build-name="$BUILD_NAME")
[[ -n "$BUILD_NUMBER" ]] && FLUTTER_ARGS+=(--build-number="$BUILD_NUMBER")

echo 'Building IPA...'
flutter build ipa "${FLUTTER_ARGS[@]}"

echo ''
echo 'IPA and archive paths:'
echo "  IPA:      $APP_ROOT/build/ios/ipa/"
echo "  Archive:  $APP_ROOT/build/ios/archive/"
if [[ -d "$APP_ROOT/build/ios/ipa" ]]; then
  echo ''
  echo 'IPA file(s):'
  ls -la "$APP_ROOT/build/ios/ipa/"
fi
