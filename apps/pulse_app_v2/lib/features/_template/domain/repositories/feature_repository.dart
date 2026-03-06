// リポジトリの abstract interface。実装は data/repositories に置く。
// コピー後: FeatureRepository / FeatureEntity を実名に置換する。

import 'package:pulse_app/features/_template/domain/entities/feature_entity.dart';

abstract interface class FeatureRepository {
  Future<FeatureEntity?> getById(String id);
  Future<void> save(FeatureEntity entity);
}
