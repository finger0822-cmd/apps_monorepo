#!/bin/bash

# ホットリスタートスクリプト
# アプリを完全に再起動します

echo "🔄 ホットリスタートを実行中..."

# 実行中のFlutterプロセスを停止
pkill -f "flutter run" 2>/dev/null
sleep 2

# アプリを再起動
echo "🚀 アプリを再起動中..."
flutter run -d CB876670-BA2A-4AF5-83D9-56EBA9857E6C &

echo "✅ アプリを再起動しました"
echo "   起動完了後、ホットリロードを試してください:"
echo "   r"
