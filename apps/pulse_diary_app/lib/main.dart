import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/storage/isar_service.dart';
import 'core/theme/app_theme.dart';
import 'features/today_log/presentation/screens/today_log_screen.dart';

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
      home: const TodayLogScreen(),
    );
  }
}
