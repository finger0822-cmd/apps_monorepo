#!/usr/bin/env bash
# Pulse を起動する。workspace/pulse.code-workspace を開いた状態でモノレポルートから実行する想定。
# 使い方: モノレポルートで ./tools/run_pulse.sh または sh tools/run_pulse.sh
# デバイス指定: ./tools/run_pulse.sh -d <デバイスID>
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT/apps/pulse_app" || exit 1
if [[ "$1" == "-d" && -n "$2" ]]; then
  flutter run -d "$2"
else
  flutter run
fi
