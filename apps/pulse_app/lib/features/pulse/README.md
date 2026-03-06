# Pulse Insights 縦スライス

AI 生成 → Isar 保存 → 一覧表示までの最小構成です。

## build_runner

Isar のコード生成を使うため、スキーマ変更後は以下を実行してください。

```bash
cd apps/pulse_app && dart run build_runner build --delete-conflicting-outputs
```

## Isar コレクション名

生成される `.g.dart` により、コレクション名が決まります。環境や Isar バージョンで名前が変わる場合があるため、生成後に以下を確認し、リポジトリ内の参照を合わせてください。

- `lib/features/pulse/infrastructure/datasources/isar/isar_insight_entity.g.dart` → `isarInsightEntitys`
- `lib/data/isar/isar_pulse_event_entity.g.dart` → `isarPulseEventEntitys`

## 差し込み方（既存 main を変えずに動作確認）

1. **Isar を開くとき**  
   `openIsar(extraSchemas: [IsarInsightEntitySchema])` を呼ぶ。  
   `IsarInsightEntitySchema` は `package:pulse_app/features/pulse/infrastructure/datasources/isar/isar_insight_entity.dart` で export されないため、  
   `import 'package:pulse_app/features/pulse/infrastructure/datasources/isar/isar_insight_entity.dart';` のうえで `IsarInsightEntitySchema` を使用する。

2. **起動後に Isar を渡す**  
   `IsarDb.setInstance(isar)` を呼ぶ（Insights 用リポジトリが IsarDb.getInstance() を使うため）。

3. **DI の組み立て**  
   - `PulseEventRepository`（features）: `IsarPulseEventRepository()`  
   - **本番**: `final llm = SupabaseEdgeLlmClient(client: Supabase.instance.client);`、`AiInsightRepository(llmClient: llm, store: IsarInsightStore())`  
   - **開発・テスト**: `AiInsightRepository(llmClient: DummyOpenAiClient(), store: IsarInsightStore())`  
   - `GenerateInsightsUsecase`: 上記 2 つを渡す。

4. **Insights 画面を表示**  
   動作確認用に `MaterialApp` の `home` を一時的に  
   `InsightsPage(generateUsecase: ..., insightRepo: ...)` にするか、名前付きルートで `/insights` に上記を表示する。

既存の `main.dart` や `PulseDependencies` は置き換えず、上記のみコメントまたは別エントリで試してください。

## Supabase Edge Function（本番 AI）

本番では OpenAI を Flutter から直接叩かず、Supabase Edge Function 経由で呼び出します。API キーは Edge Function の環境変数のみに置きます。

- **配置**: `supabase/functions/generate-pulse-insight/`（プロジェクトで `supabase link` するルートに `supabase/` を置く想定）
- **デプロイ**: `supabase functions deploy generate-pulse-insight`
- **シークレット**: `supabase secrets set OPENAI_API_KEY=<your-key>`
- **Flutter 前提**: `pubspec.yaml` に `supabase_flutter` を追加し、起動時に `Supabase.initialize(url: ..., anonKey: ...)` を実行すること。

### 手元で実行するコマンド

- Flutter: `cd apps/pulse_app && flutter pub get`（supabase_flutter 追加後）
- Supabase ログイン（未実施時）: `supabase login`
- プロジェクト紐付け: 対象プロジェクトのルートで `supabase link`
- デプロイ: `supabase functions deploy generate-pulse-insight`
- シークレット: `supabase secrets set OPENAI_API_KEY=<your-key>`
- 動作確認: アプリ起動前に `Supabase.initialize(url: ..., anonKey: ...)` を実行し、本番 DI で `SupabaseEdgeLlmClient(client: Supabase.instance.client)` を渡して Insights の「Generate」を実行する。
