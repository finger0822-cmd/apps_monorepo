import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../domain/models/mind_entry.dart';

/// 未開封のタイムカプセル一覧
final sealedCapsulesProvider =
    FutureProvider<List<MindEntry>>((ref) async {
  final repo = ref.watch(entryRepositoryProvider);
  return repo.getSealedCapsules();
});

/// 開封済みタイムカプセル一覧
final openedCapsulesProvider =
    FutureProvider<List<MindEntry>>((ref) async {
  final repo = ref.watch(entryRepositoryProvider);
  return repo.getOpenedCapsules();
});
