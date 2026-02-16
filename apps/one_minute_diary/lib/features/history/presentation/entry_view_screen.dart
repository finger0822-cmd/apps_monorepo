import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../entry/data/entry_repository.dart';

class EntryViewScreen extends ConsumerWidget {
  const EntryViewScreen({super.key, required this.entryId});

  final int entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsync = ref.watch(entryByIdProvider(entryId));

    return Scaffold(
      appBar: AppBar(title: const Text('Entry')),
      body: entryAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, stackTrace) => const Center(
          child: Text(
            'Failed to load entry.',
            style: TextStyle(color: Colors.white),
          ),
        ),
        data: (entry) {
          if (entry == null) {
            return const Center(
              child: Text(
                'Entry not found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.date,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      entry.text,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.6,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
