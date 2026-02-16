#!/bin/bash

# Flutterホットリロードスクリプト
# 実行中のFlutterアプリにホットリロードを送信します
# 使用方法: ./hot_reload.sh または ./reload

echo "🔄 ホットリロードを実行中..."

# Pythonスクリプトが存在する場合はそれを使用
if [ -f "hot_reload.py" ] && command -v python3 > /dev/null 2>&1; then
    python3 hot_reload.py
    exit $?
fi

# 実行中のFlutterプロセスを確認
FLUTTER_RUN_PID=$(ps aux | grep -i "flutter run" | grep -v grep | awk '{print $2}' | head -1)

if [ -z "$FLUTTER_RUN_PID" ]; then
    echo "❌ 実行中のFlutterプロセスが見つかりません"
    echo "   まず 'flutter run' を実行してください"
    exit 1
fi

echo "📍 Flutterプロセスが見つかりました (PID: $FLUTTER_RUN_PID)"
echo ""
echo "📝 ホットリロードを実行する方法:"
echo ""
echo "   方法1: Flutter実行中のターミナルウィンドウにフォーカスを当てて"
echo "   - 'r' キーを押す（ホットリロード）"
echo "   - 'R' キーを押す（ホットリスタート）"
echo "   - 'q' キーを押す（アプリを終了）"
echo ""
echo "   方法2: 別のターミナルで以下を実行:"
echo "   flutter attach"
echo "   (接続後、'r' キーでホットリロード、'q' で終了)"
echo ""
echo "   方法3: Pythonスクリプトを使用（websocket-clientが必要）:"
echo "   pip3 install websocket-client"
echo "   python3 hot_reload.py"
echo ""
