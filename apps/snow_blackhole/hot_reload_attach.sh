#!/bin/bash

# flutter attachを使用してホットリロードを実行するスクリプト
# このスクリプトは、expectを使用して自動的にホットリロードを実行します

echo "🔄 flutter attachでホットリロードを実行中..."

# expectがインストールされているか確認
if ! command -v expect > /dev/null 2>&1; then
    echo "❌ expectコマンドが見つかりません"
    echo "   インストール: brew install expect"
    exit 1
fi

# expectスクリプトを実行
expect << 'EOF'
set timeout 10
spawn flutter attach

expect {
    "Waiting for a connection from Flutter on" {
        puts "接続を待機中..."
    }
    "Flutter run key commands" {
        puts "既に接続されています"
    }
    "The Flutter DevTools" {
        puts "接続成功"
    }
    timeout {
        puts "タイムアウトしました"
        exit 1
    }
}

# 少し待ってから 'r' キーを送信
sleep 1
send "r\r"

expect {
    "Performing hot reload" {
        puts "✅ ホットリロードが実行されました"
    }
    "Hot reload performed" {
        puts "✅ ホットリロードが完了しました"
    }
    timeout {
        puts "⚠️  ホットリロードの結果が確認できませんでした"
    }
}

# 接続を終了
send "q\r"
expect eof
EOF

echo "完了"
