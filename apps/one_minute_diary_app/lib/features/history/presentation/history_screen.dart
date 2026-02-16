import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../entry/data/entry_repository.dart';
import 'entry_view_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(allEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          '履歴',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: entriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.black),
        ),
        error: (error, stackTrace) => const Center(
          child: Text('履歴を読み込めませんでした'),
        ),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Text(
                'まだ日記はありません',
                style: TextStyle(fontSize: 16, color: Color(0xFF616161)),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: entries.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final entry = entries[index];
              final preview = _firstLine(entry.text);

              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                title: Text(
                  entry.date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF616161),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => EntryViewScreen(entryId: entry.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _firstLine(String text) {
    final lines = text.split('\n');
    if (lines.isEmpty) {
      return '';
    }
    return lines.first.trim();
  }
}
