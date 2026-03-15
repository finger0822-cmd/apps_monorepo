import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_providers.dart';
import '../../domain/models/mind_entry.dart';

/// 履歴一覧（日付降順）。通常日記のみ、または全件取得。
final historyEntriesProvider = FutureProvider<List<MindEntry>>((ref) async {
  final repo = ref.watch(entryRepositoryProvider);
  final list = await repo.getAll();
  // 日付降順は getAll の仕様で既に sortByCreatedAtDesc されている想定
  return list;
});
