// data モデル ⇔ domain エンティティの変換。必要なら使用する。
// コピー後: FeatureMapper / FeatureEntity を実名に置換する。

import 'package:pulse_app/features/_template/domain/entities/feature_entity.dart';

class FeatureMapper {
  static FeatureEntity fromModel(dynamic model) {
    return FeatureEntity(id: model.id as String);
  }

  static dynamic toModel(FeatureEntity entity) => {'id': entity.id};
}
