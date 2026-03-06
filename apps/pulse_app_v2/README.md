# pulse_app

**Pulse** — 状態観測用の Flutter アプリです。

- **場所**: `~/Developer/apps_monorepo/apps/pulse_app`（モノレポ内）
- **内容**: 体力・集中・疲れを 1〜5 で観測する「静かな状態観測面」UI（TodayLogScreen）
- **起動**: `flutter run -d <デバイスID>`（例: iPhone シミュレータ）

Pulse を編集するときは、Cursor で **このフォルダ（pulse_app）を開く**とワークスペース名とアプリ名が揃います。

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, see the [online documentation](https://docs.flutter.dev/).

## 課金（サブスク Free/Pro）

- **商品 ID**: `lib/billing/product_ids.dart` の `BillingProductIds` で一元管理している。本番では App Store Connect / Play Console で作成したサブスクの ID に差し替えるだけでよく、他コードの変更は不要。
- **Pro 判定（MVP）**: 購読 ID に一致する購入/復元が確認できた場合、暫定的に Pro とする。キャンセル状態の正確な判定は本番（サーバ検証）に回す。
- **expiresAt / trialActive**: 端末のみでは正確な期限・トライアル判定が難しいため、MVP では未使用（null/false）。将来は Supabase Edge Function でレシート検証し正確化する想定。
