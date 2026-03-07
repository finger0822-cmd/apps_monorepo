import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/storage/isar_service.dart';
import '../../../../domain/models/diary_entry.dart';

/// 過去N日分のエントリを日付昇順で取得
final insightsEntriesProvider = FutureProvider.family<List<DiaryEntry>, int>(
  (ref, days) async {
    final isar = ref.watch(isarProvider);
    final since = DateTime.now().subtract(Duration(days: days));
    return isar.diaryEntrys
        .where()
        .anyId()
        .filter()
        .createdAtGreaterThan(since, include: true)
        .sortByCreatedAt()
        .findAll();
  },
);
