// UseCase。execute() を基本。domain 内のみ参照（entity, repository interface）。
// コピー後: DoSomethingUseCase / FeatureRepository を実名に置換する。

import 'package:pulse_app/features/_template/domain/entities/feature_entity.dart';
import 'package:pulse_app/features/_template/domain/repositories/feature_repository.dart';

class DoSomethingUseCase {
  DoSomethingUseCase(this._repo);

  final FeatureRepository _repo;

  Future<FeatureEntity?> execute(String id) => _repo.getById(id);
}
