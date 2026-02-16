#!/bin/bash

# rコマンドとRコマンドのエイリアスを設定するスクリプト
# このスクリプトを実行すると、~/.zshrcにエイリアスが追加されます

ALIAS_R="alias r='cd /Users/user/Desktop/snow_blackhole && ./hot_reload.sh'"
ALIAS_R_CAPITAL="alias R='cd /Users/user/Desktop/snow_blackhole && ./hot_restart.sh'"
ZSHRC_FILE="$HOME/.zshrc"

echo "🔧 rコマンドとRコマンドのエイリアスを設定中..."

# .zshrcファイルが存在するか確認
if [ ! -f "$ZSHRC_FILE" ]; then
    echo "📝 .zshrcファイルを作成します..."
    touch "$ZSHRC_FILE"
fi

# 既にエイリアスが設定されているか確認
if grep -q "alias r=" "$ZSHRC_FILE"; then
    echo "⚠️  既にrエイリアスが設定されています"
    read -p "上書きしますか？ (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "キャンセルしました"
        exit 0
    fi
    # 既存のエイリアスを削除
    sed -i.bak '/alias r=/d' "$ZSHRC_FILE"
fi

if grep -q "alias R=" "$ZSHRC_FILE"; then
    echo "⚠️  既にRエイリアスが設定されています"
    read -p "上書きしますか？ (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "キャンセルしました"
        exit 0
    fi
    # 既存のエイリアスを削除
    sed -i.bak '/alias R=/d' "$ZSHRC_FILE"
fi

# エイリアスを追加
echo "" >> "$ZSHRC_FILE"
echo "# snow_blackhole プロジェクト用の設定" >> "$ZSHRC_FILE"
echo "$ALIAS_R" >> "$ZSHRC_FILE"
echo "$ALIAS_R_CAPITAL" >> "$ZSHRC_FILE"

echo "✅ エイリアスを追加しました"
echo ""
echo "📝 次のコマンドを実行して設定を反映してください:"
echo "   source ~/.zshrc"
echo ""
echo "または、新しいターミナルを開いてください"
echo ""
echo "その後、以下のコマンドでホットリロード/ホットリスタートを実行できます:"
echo "   r  - ホットリロード"
echo "   R  - ホットリスタート（完全再起動）"
