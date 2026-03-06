// 上記 domain の FeatureRepository interface の実装。data 層のみ。
// コピー後: FeatureRepositoryImpl / FeatureRepository を実名に置換する。

import 'package:pulse_app/features/_template/domain/entities/feature_entity.dart';
import 'package:pulse_app/features/_template/domain/repositories/feature_repository.dart';

class FeatureRepositoryImpl implements FeatureRepository {
  @override
  Future<FeatureEntity?> getById(String id) async => null;

  @override
  Future<void> save(FeatureEntity entity) async {}
}
