import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mind_capsule_app/services/revenue_cat_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/l10n/app_strings.dart';
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
import 'features/settings/settings_provider.dart';
import 'features/stats/stats_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RevenueCatService.initialize();
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

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});
  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;
  static const _screens = [
    RecordScreen(),
    HistoryScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(appLanguageProvider);
    final s = AppStrings.of(lang);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        indicatorColor: AppTheme.lightPurple,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.edit_note, size: 26), label: s.tabRecord),
          NavigationDestination(icon: const Icon(Icons.history, size: 26), label: s.tabHistory),
          NavigationDestination(icon: const Icon(Icons.show_chart, size: 26), label: s.tabStats),
          NavigationDestination(icon: const Icon(Icons.settings, size: 26), label: s.tabSettings),
        ],
      ),
    );
  }
}
