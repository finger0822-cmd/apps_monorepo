import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/notifications/notification_service.dart';
import 'core/providers/app_providers.dart';
import 'core/services/claude_service.dart';
import 'core/storage/api_key_storage.dart';
import 'core/storage/isar_service.dart';
import 'data/repositories/entry_repository_impl.dart';
import 'core/theme/app_theme.dart';
import 'features/history/history_screen.dart';
import 'features/record/record_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/stats/stats_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja_JP', null);
  final isar = await IsarService.open();
  await NotificationService.initialize();
  await NotificationService.requestPermissions();
  final repo = EntryRepositoryImpl(
    isar: isar,
    claudeService: ClaudeService(),
    apiKeyStorage: ApiKeyStorageImpl(),
  );
  runApp(
    ProviderScope(
      overrides: <Override>[
        isarProvider.overrideWithValue(isar),
        entryRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MindCapsuleApp(),
    ),
  );
}

class MindCapsuleApp extends StatelessWidget {
  const MindCapsuleApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindCapsule',
      theme: AppTheme.light,
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  static const _screens = [
    RecordScreen(),
    HistoryScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        indicatorColor: AppTheme.lightPurple,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.edit_note, size: 26),
            label: '記録',
          ),
          NavigationDestination(
            icon: Icon(Icons.history, size: 26),
            label: '履歴',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart, size: 26),
            label: 'グラフ',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, size: 26),
            label: '設定',
          ),
        ],
      ),
    );
  }
}
