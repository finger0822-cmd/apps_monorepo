#!/usr/bin/env python3
"""
Flutterホットリロードスクリプト
実行中のFlutterアプリにホットリロードを送信します
"""

import json
import sys
import os
import re
from pathlib import Path

def find_vm_service_url():
    """ログファイルからVM Service URLを取得"""
    log_dir = Path.home() / ".cursor" / "projects" / "Users-user-Desktop-rain-blackhole" / "terminals"
    
    if not log_dir.exists():
        return None
    
    # 最新のログファイルを取得
    log_files = sorted(log_dir.glob("*.txt"), key=lambda p: p.stat().st_mtime, reverse=True)
    
    for log_file in log_files:
        try:
            with open(log_file, 'r', encoding='utf-8') as f:
                content = f.read()
                # VM Service URLを検索
                match = re.search(r'http://127\.0\.0\.1:\d+/[^/\s]+/', content)
                if match:
                    return match.group(0)
        except Exception:
            continue
    
    return None

def main():
    import sys
    
    # コマンドライン引数を確認
    if len(sys.argv) > 1 and sys.argv[1] == "--restart":
        print("🔄 ホットリスタートを実行中...")
        # ホットリスタートの実装は後で追加
        print("⚠️  ホットリスタート機能は現在実装中です")
        print("   代わりに、アプリを再起動してください:")
        print("   1. 実行中のFlutterプロセスを停止 (qキーまたはCtrl+C)")
        print("   2. flutter run を再度実行")
        return
    
    vm_service_url = find_vm_service_url()
    
    if not vm_service_url:
        print("❌ VM Service URLが見つかりません")
        print("   まず 'flutter run' を実行してください")
        sys.exit(1)
    
    print(f"📍 VM Service URL: {vm_service_url}")
    print("🔄 ホットリロードを実行中...")
    
    # WebSocketを使用してホットリロードを実行
    try:
        import websocket
    except ImportError:
        print("⚠️  websocket-clientパッケージが必要です")
        print("   インストール: pip3 install websocket-client")
        sys.exit(1)
    
    ws_url = vm_service_url.replace("http://", "ws://") + "ws"
    
    try:
        ws = websocket.create_connection(ws_url, timeout=5)
        
        # まず、isolateIdを取得
        get_vm_request = {
            "jsonrpc": "2.0",
            "method": "getVM",
            "id": "1"
        }
        
        ws.send(json.dumps(get_vm_request))
        vm_response = ws.recv()
        vm_result = json.loads(vm_response)
        
        if "error" in vm_result:
            print(f"❌ VM情報の取得に失敗: {vm_result['error']}")
            ws.close()
            sys.exit(1)
        
        # isolateIdを取得（最初のisolateを使用）
        isolate_id = None
        if "result" in vm_result and "isolates" in vm_result["result"]:
            isolates = vm_result["result"]["isolates"]
            if len(isolates) > 0:
                isolate_id = isolates[0]["id"]
        
        if not isolate_id:
            print("❌ isolateIdが見つかりません")
            ws.close()
            sys.exit(1)
        
        print(f"📍 Isolate ID: {isolate_id}")
        
        # reloadSourcesリクエストを送信
        request = {
            "jsonrpc": "2.0",
            "method": "reloadSources",
            "params": {
                "isolateId": isolate_id,
                "pause": False
            },
            "id": "2"
        }
        
        ws.send(json.dumps(request))
        response = ws.recv()
        ws.close()
        
        result = json.loads(response)
        
        if "result" in result:
            if "success" in result["result"]:
                success = result["result"]["success"]
                if success:
                    print("✅ ホットリロードが成功しました")
                else:
                    print("⚠️  ホットリロードが失敗しました")
                    if "notices" in result["result"]:
                        for notice in result["result"]["notices"]:
                            print(f"   通知: {notice}")
                    print("\n💡 ホットリスタートを試してください:")
                    print("   python3 hot_reload.py --restart")
                    print("   または、アプリを再起動してください")
            else:
                print("✅ ホットリロードが完了しました")
        elif "error" in result:
            print(f"❌ エラー: {result['error']}")
            print("\n💡 ホットリスタートを試してください:")
            print("   python3 hot_reload.py --restart")
        else:
            print(f"⚠️  予期しないレスポンス: {response}")
            
    except Exception as e:
        print(f"❌ エラーが発生しました: {e}")
        print("")
        print("📝 代替方法:")
        print("   Flutter実行中のターミナルで 'r' キーを押してください")
        sys.exit(1)

if __name__ == "__main__":
    main()
