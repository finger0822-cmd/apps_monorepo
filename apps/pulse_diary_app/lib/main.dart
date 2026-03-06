import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/storage/isar_service.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isar = await IsarService.open();

  runApp(
    ProviderScope(
      overrides: <Override>[isarProvider.overrideWithValue(isar)],
      child: const PulseDiaryApp(),
    ),
  );
}

class PulseDiaryApp extends StatelessWidget {
  const PulseDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pulse Diary',
      theme: AppTheme.light,
      home: const _PlaceholderHome(),
    );
  }
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulse Diary'),
      ),
      body: const Center(
        child: Text('Pulse Diary'),
      ),
    );
  }
}
