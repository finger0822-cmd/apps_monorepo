#!/usr/bin/env bash
# Architecture guard: forbidden imports for Feature First × Clean Architecture.
# - domain: no Flutter / Riverpod / Isar / Supabase
# - presentation: no direct import of feature data layer
# Run from repo root: ./scripts/arch_check.sh

set -e
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_FEATURES="${REPO_ROOT}/apps/pulse_app_v2/lib/features"
FAILED=0

if [[ ! -d "$LIB_FEATURES" ]]; then
  echo "arch_check.sh: lib/features not found at $LIB_FEATURES"
  exit 1
fi

# --- Domain: forbidden packages (pure Dart only) ---
DOMAIN_FORBIDDEN='package:flutter|package:flutter_riverpod|package:isar|package:isar_flutter_libs|package:supabase|package:path_provider'
if domain_files=$(find "$LIB_FEATURES" -path "*/domain/*" -name "*.dart" 2>/dev/null); then
  while IFS= read -r f; do
    if [[ -f "$f" ]] && grep -qE "import ['\"]($DOMAIN_FORBIDDEN)" "$f" 2>/dev/null; then
      echo "[DOMAIN] Forbidden import in: $f"
      grep -nE "import ['\"]($DOMAIN_FORBIDDEN)" "$f" || true
      FAILED=1
    fi
  done <<< "$domain_files"
fi

# --- Presentation: must not import feature data layer ---
PRESENTATION_FORBIDDEN='features/[^/]+/data/'
if pres_files=$(find "$LIB_FEATURES" -path "*/presentation/*" -name "*.dart" 2>/dev/null); then
  while IFS= read -r f; do
    if [[ -f "$f" ]] && grep -qE "import.*$PRESENTATION_FORBIDDEN" "$f" 2>/dev/null; then
      echo "[PRESENTATION] Direct data import forbidden in: $f"
      grep -nE "import.*$PRESENTATION_FORBIDDEN" "$f" || true
      FAILED=1
    fi
  done <<< "$pres_files"
fi

if [[ $FAILED -eq 1 ]]; then
  echo "arch_check.sh: architecture violations found (see above)."
  exit 1
fi
echo "arch_check.sh: OK (no forbidden imports)."
exit 0
