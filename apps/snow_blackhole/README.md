# snow_blackhole

A Flutter app with snow particles and tap blackhole effect.

## Getting Started

### アプリの起動

```bash
flutter run
```

### ホットリロード

#### 方法1: `r`コマンドを使用（以前と同じ方法）

まず、エイリアスを設定します：

```bash
./setup_r_alias.sh
source ~/.zshrc
```

その後、以下のコマンドでホットリロードを実行できます：

```bash
r
```

#### 方法2: Pythonスクリプトを使用（推奨・最も簡単）

```bash
python3 hot_reload.py
```

または短縮版：

```bash
./hot_reload.sh
```

または：

```bash
./r
```

このスクリプトは自動的にVM Service URLを検出してホットリロードを実行します。

#### 方法3: flutter attachを使用（最も確実）

別のターミナル（macOSのTerminal.appやiTerm2）で：

```bash
cd /Users/user/Desktop/snow_blackhole
flutter attach
```

接続後：
- `r` キー: ホットリロード
- `R` キー: ホットリスタート（完全再起動）
- `q` キー: アプリを終了

#### 方法4: Flutter実行中のターミナルで直接

**注意**: Cursorの統合ターミナルでは動作しない場合があります。

Flutterアプリが実行中のターミナルウィンドウにフォーカスを当てて：
- `r` キー: ホットリロード（コマンドではなく、キーを押す）
- `R` キー: ホットリスタート（完全再起動）
- `q` キー: アプリを終了

## 使い方

- 画面をタップすると、その位置にブラックホールが生成されます
- 雨粒がブラックホールに引き寄せられます
- タップを離すとブラックホールが消えます
- ドラッグでもブラックホールを移動できます

## トラブルシューティング

### `r`コマンドが動作しない場合

以前は`r`コマンドでホットリロードができていた場合、エイリアスを設定する必要があります：

```bash
./setup_r_alias.sh
source ~/.zshrc
```

その後、`r`コマンドでホットリロードを実行できます。

### `r`コマンドを実行するとエラーになる場合

`r`はzshの組み込みコマンド（履歴再実行）として存在するため、エイリアスが設定されていない場合は動作しません。

**解決方法：**

1. **エイリアスを設定する**（推奨）
   ```bash
   ./setup_r_alias.sh
   source ~/.zshrc
   ```

2. **Pythonスクリプトを使用**
   ```bash
   python3 hot_reload.py
   ```

3. **別のターミナルアプリを使用**
   - macOSのTerminal.appやiTerm2を開く
   - プロジェクトディレクトリに移動
   - `flutter attach`を実行
   - 接続後、`r`キーでホットリロード

### ターミナルに入力できない場合

Cursorの統合ターミナルでは、Flutter実行中のプロセスに直接入力できない場合があります。

**解決方法：**

1. **`r`コマンドを使用**（エイリアス設定後）
   ```bash
   r
   ```

2. **Pythonスクリプトを使用**（最も簡単）
   ```bash
   python3 hot_reload.py
   ```

3. **別のターミナルアプリを使用**
   - macOSのTerminal.appやiTerm2を開く
   - プロジェクトディレクトリに移動
   - `flutter attach`を実行
   - 接続後、`r`キーでホットリロード

## 開発

コードを変更して保存すると、ホットリロードが自動的に実行される場合があります（IDEの設定による）。

手動でホットリロードを実行する場合は、上記の方法を使用してください。
