# pulse_app_v2: Feature First × Clean Architecture × Riverpod リファクタ成果物

**更新ルール**: このファイルは lib の構造・ルールと一致させる。ツリー・責務・接続図・コマンドを変更したら必ずここを更新する。

## 最終ディレクトリツリー

```
lib/
  main.dart
  core/
    config/config.dart
    constants/constants.dart
    errors/errors.dart
    extensions/extensions.dart
    isar_provider.dart
    network/network.dart
    pulse_dependencies.dart
    theme/app_theme.dart
    utils/utils.dart
  shared/
    localization/localization.dart
    widgets/widgets.dart
  features/
    features.dart
    _template/          # 新 feature 追加用雛形（コピーして使う）
    pulse/
      presentation/screens/today_log_screen.dart
      application/
        providers/pulse_providers.dart
        state/state.dart
      domain/
        entities/daily_state.dart
        metrics/pulse_metric.dart
        pulse_domain.dart
        repositories/daily_state_repository.dart
        usecases/
          daily_state_upsert_usecase.dart
          log_metric_usecase.dart
        utils/date_utils.dart
      data/
        mappers/daily_state_mapper.dart
        models/
          isar_pulse_event_entity.dart, .g.dart
          pulse_log_entity.dart, .g.dart
        repositories/
          daily_state_repository_impl.dart
          isar_pulse_event_repository_impl.dart
          isar_state_repository_impl.dart
  l10n/
    app_*.arb, app_localizations*.dart
```

## feature ごとの責務（pulse）

- **presentation**: 今日のログ画面（TodayLogScreen）。Provider を watch して UseCase を呼ぶだけ。
- **application**: Riverpod Provider（pulseDependenciesProvider, dailyStateUpsertUsecaseProvider, logMetricUseCaseProvider）と state プレースホルダ。
- **domain**: エンティティ（DailyState）、値オブジェクト・イベント（pulse_domain）、リポジトリ interface（DailyStateRepository, PulseEventRepository）、UseCase（DailyStateUpsertUsecase, LogMetricUseCase）。Flutter/Riverpod/Isar/core_state に依存しない。
- **data**: Isar モデル、mapper（DailyStateMapper）、リポジトリ実装（DailyStateRepositoryImpl, IsarStateRepository, IsarPulseEventRepository）。core_state への依存は data に閉じている。

## Provider / UseCase / Repository 接続図

```
main()
  └─ ProviderScope(overrides: [pulseDependenciesProvider])
       └─ PulseApp
            └─ TodayLogScreen
                 └─ ref.read(dailyStateUpsertUsecaseProvider) → DailyStateUpsertUsecase

pulseDependenciesProvider (override で bootstrap 結果を注入)
  └─ PulseDependencies { usecase, logMetricUseCase }

dailyStateUpsertUsecaseProvider
  └─ ref.watch(pulseDependenciesProvider).usecase → DailyStateUpsertUsecase

DailyStateUpsertUsecase
  └─ DailyStateRepository (domain interface)
       └─ DailyStateRepositoryImpl (data) → IsarStateRepository (core_state) + DailyStateMapper

LogMetricUseCase
  └─ PulseEventRepository (domain, pulse_domain)
       └─ IsarPulseEventRepository (data)
```

他から pulse を使うときは `import 'package:pulse_app/features/pulse/pulse_feature.dart';` または `import 'package:pulse_app/features/features.dart';` を利用する。

## 実行コマンド

```bash
cd apps/pulse_app_v2
flutter pub get
flutter analyze lib/
flutter run
```

リポジトリルートで依存方向チェック:

```bash
./scripts/arch_check.sh
```

Isar のスキーマ変更時:

```bash
cd apps/pulse_app_v2 && dart run build_runner build -d
```

## 依存方向

- presentation → application (Provider) → domain (UseCase / interface)
- domain → なし（純 Dart）
- data → domain（entity / interface）、core_state（mapper 内のみ）、Isar

## ローカル確認手順

1. `flutter pub get`
2. `flutter analyze lib/` または `dart analyze lib/`
3. `flutter run` で起動確認

---

## 運用ルール（ガードレール）

### 新規ファイルを追加するときの置き場所

- 画面・Widget → 当該 feature の `presentation/screens` または `presentation/widgets`
- Provider → 当該 feature の `application/providers`（domain に Provider は置かない）
- エンティティ・Repository interface・UseCase → 当該 feature の `domain/`
- 永続化・API・mapper・Repository 実装 → 当該 feature の `data/`

### Provider を追加するときのルール

- 定義する場所は **application/providers のみ**。domain 層には Riverpod を import しない。
- 画面からは `ref.watch` / `ref.read` で参照し、UseCase や Repository を直接 new しない。

### チェック方法（手順）

- **静的解析**: `flutter analyze lib/` または `dart analyze lib/`
- **依存方向・禁止 import**: リポジトリルートで `./scripts/arch_check.sh` を実行（domain の Flutter/Riverpod/Isar 禁止、presentation の data 直接 import 禁止）
- **Isar スキーマ変更時**: `dart run build_runner build -d`
- **l10n**: `flutter gen-l10n` またはプロジェクトの l10n 手順（arb-dir は変更しない）

### 変更時の更新箇所

- ディレクトリツリーが変わったら、この REFACTOR_SUMMARY.md の「最終ディレクトリツリー」を更新する。
- 新 feature 追加時は、「feature ごとの責務」と「Provider / UseCase / Repository 接続図」に追記する。

---

## ガードレール化の成果物（崩壊防止仕上げ）

### 1. 追加・変更・削除したファイル一覧

**追加**
- `scripts/arch_check.sh`（リポジトリルート）
- `lib/features/_template/` 一式（presentation/screens, application/providers, domain/entities, domain/repositories, domain/usecases, data/datasources/local, data/repositories, data/mappers）
- `lib/features/_template/README.md`

**変更**
- `docs/REFACTOR_SUMMARY.md`（更新ルール・運用ルール・チェック方法・実行コマンド・ガードレール成果物を追記）
- `lib/features/_template/application/providers/feature_providers.dart`（dart fix による未使用 import 削除）

**削除**
- なし（参照 0 の未使用ファイルはプレースホルダのため残した）

### 2. ガードレールの仕様（何を禁止しているか）

- **domain**: `package:flutter`, `package:flutter_riverpod`, `package:isar`, `package:isar_flutter_libs`, `package:supabase`, `package:path_provider` の import を禁止。純 Dart のみ。
- **presentation**: 当該 feature の `data` 層の直接 import を禁止（application / domain 経由のみ）。
- **検知**: `./scripts/arch_check.sh` が上記パターンを grep で検出し、違反があれば exit 1。

### 3. 新 feature 追加テンプレの使い方（3 手順）

1. `lib/features/_template/` をコピーし、`lib/features/<feature_name>/` にリネームする（`<feature_name>` は snake_case）。
2. 各ファイル内の `feature` / `Feature` / `_template` 等のプレースホルダを `<feature_name>` に置換する。
3. 実装を追加し、main またはルートで当 feature の画面・Provider を配線する。詳細は `lib/features/_template/README.md` を参照。

### 4. 実行コマンド一覧

| 目的 | コマンド |
|------|----------|
| 依存取得 | `cd apps/pulse_app_v2 && flutter pub get` |
| 静的解析 | `cd apps/pulse_app_v2 && flutter analyze lib/` |
| 依存方向チェック | リポジトリルートで `./scripts/arch_check.sh` |
| Isar 再生成 | `cd apps/pulse_app_v2 && dart run build_runner build -d` |
| 起動 | `cd apps/pulse_app_v2 && flutter run` |
