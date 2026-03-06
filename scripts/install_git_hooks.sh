#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"
HOOKS_DIR="$ROOT_DIR/.git/hooks"

mkdir -p "$HOOKS_DIR"
chmod +x "$ROOT_DIR/scripts/hooks/pre-commit"
ln -sf "$ROOT_DIR/scripts/hooks/pre-commit" "$HOOKS_DIR/pre-commit"

echo "Installed: .git/hooks/pre-commit -> scripts/hooks/pre-commit"
