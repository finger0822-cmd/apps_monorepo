/// Pulse feature の公開 API。他 feature や main からはこのファイルを import して利用する。
///
/// 表示用指標定義（class [PulseMetric]）は [pulse_domain] の enum と同名のため
/// barrel では export していない。必要な場合は
/// `import 'package:pulse_app/features/pulse/domain/metrics/pulse_metric.dart';` を直接使用する。
library;

export 'presentation/pages/insights_page.dart';
export 'presentation/pages/today_page.dart';
export 'application/providers/pulse_providers.dart';
export 'domain/pulse_domain.dart';
