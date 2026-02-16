#!/bin/bash

# flutter attachを実行してホットリロードを自動実行するスクリプト
# このスクリプトは、macOSのTerminal.appやiTerm2で実行してください

echo "🔄 flutter attachでホットリロードを実行中..."
echo ""
echo "注意: このスクリプトは別のターミナルアプリ（Terminal.appやiTerm2）で実行してください"
echo ""

# expectがインストールされているか確認
if ! command -v expect > /dev/null 2>&1; then
    echo "❌ expectコマンドが見つかりません"
    echo "   インストール: brew install expect"
    exit 1
fi

# expectスクリプトを実行
expect << 'EOF'
set timeout 15
spawn flutter attach

expect {
    "Waiting for a connection from Flutter on" {
        puts "\n⏳ Flutterアプリへの接続を待機中..."
        expect {
            "The Flutter DevTools" {
                puts "✅ 接続成功！"
            }
            timeout {
                puts "❌ タイムアウト: Flutterアプリが実行中か確認してください"
                exit 1
            }
        }
    }
    "The Flutter DevTools" {
        puts "✅ 既に接続されています"
    }
    "Flutter run key commands" {
        puts "✅ 接続成功！"
    }
    timeout {
        puts "❌ タイムアウト: Flutterアプリが実行中か確認してください"
        exit 1
    }
}

# 少し待ってから 'r' キーを送信
sleep 1
puts "\n🔥 ホットリロードを実行中..."
send "r\r"

expect {
    "Performing hot reload" {
        puts "✅ ホットリロードが実行されました"
    }
    "Hot reload performed" {
        puts "✅ ホットリロードが完了しました"
    }
    "Reloaded" {
        puts "✅ リロード完了"
    }
    "No implementation found" {
        puts "⚠️  ホットリロードに失敗しました（コードに問題がある可能性があります）"
    }
    timeout {
        puts "⚠️  ホットリロードの結果が確認できませんでした"
    }
}

# 接続を終了
sleep 1
send "q\r"
expect eof
EOF

echo ""
echo "完了"
