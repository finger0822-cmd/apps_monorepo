#!/bin/bash
set -e
echo '🌐 Validating i18n files...'
FILE='lib/core/l10n/app_strings.dart'

if [ ! -f "$FILE" ]; then
    echo "❌ File not found: $FILE"
    exit 1
fi

echo "📖 Checking $FILE..."

# Find getters/methods that have _isEn ternary
TOTAL=$(grep -c '_isEn ?' "$FILE" || true)
# Find any getter/method that does NOT use _isEn (i.e. missing translation)
MISSING=$(grep -E '^\s+String (get \w+|\w+\()' "$FILE" | grep -v '_isEn' | grep -v '//' || true)

echo "✅ Entries with both EN/JA: $TOTAL"

if [ -z "$MISSING" ]; then
    echo '✅ All string getters have translations!'
else
    echo '⚠️  Getters possibly missing _isEn translation:'
    echo "$MISSING"
fi
