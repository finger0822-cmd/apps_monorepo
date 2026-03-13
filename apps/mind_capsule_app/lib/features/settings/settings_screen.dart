import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/providers/app_providers.dart';
import '../../domain/models/mind_entry.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _obscureApiKey = true;
  bool _isSavingKey = false;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveApiKey() async {
    final key = _apiKeyController.text.trim();
    if (key.isEmpty) {
      if (mounted) {
        final s = AppStrings.of(ref.read(appLanguageProvider));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.settingsApiKeyEmpty)),
        );
      }
      return;
    }
    setState(() => _isSavingKey = true);
    await ref.read(apiKeyAsyncProvider.notifier).save(key);
    if (mounted) {
      setState(() => _isSavingKey = false);
      _apiKeyController.clear();
      final s = AppStrings.of(ref.read(appLanguageProvider));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.settingsApiKeySaved)),
      );
    }
  }

  Future<void> _deleteApiKey() async {
    await ref.read(apiKeyAsyncProvider.notifier).delete();
    if (mounted) {
      final s = AppStrings.of(ref.read(appLanguageProvider));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.settingsApiKeyDeleted)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiKeyAsync = ref.watch(apiKeyAsyncProvider);
    final settingsAsync = ref.watch(settingsProvider);
    final lang = ref.watch(appLanguageProvider);
    final s = AppStrings.of(lang);

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Claude API キー ──
          Text(s.settingsApiKey,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          apiKeyAsync.when(
            data: (key) {
              if (key != null && key.isNotEmpty) {
                final display =
                    key.length > 20 ? '${key.substring(0, 20)}...' : key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Colors.green.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(display,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontFamily: 'monospace')),
                      ),
                      TextButton(
                          onPressed: _deleteApiKey,
                          child: Text(s.settingsApiKeyDelete)),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureApiKey,
            decoration: InputDecoration(
              hintText: 'sk-ant-...',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureApiKey
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () =>
                    setState(() => _obscureApiKey = !_obscureApiKey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _isSavingKey ? null : _saveApiKey,
            child: _isSavingKey
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(s.settingsApiKeySave),
          ),
          const SizedBox(height: 24),

          // ── 言語 ──
          Text(s.settingsLanguage, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          settingsAsync.when(
            data: (state) => SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ja', label: Text('日本語')),
                ButtonSegment(value: 'en', label: Text('English')),
              ],
              selected: {state.language},
              onSelectionChanged: (s) async {
                await ref.read(settingsProvider.notifier).setLanguage(s.first);
              },
            ),
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('読み込みエラー'),
          ),
          const SizedBox(height: 24),

          // ── 通知 ──
          Text(s.settingsNotifications, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          settingsAsync.when(
            data: (state) => Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: SwitchListTile(
                title: Text(s.settingsReminderTitle),
                subtitle: Text(s.settingsReminderSubtitle),
                value: state.notificationsEnabled,
                onChanged: (v) async {
                  await ref
                      .read(settingsProvider.notifier)
                      .setNotificationsEnabled(v);
                },
              ),
            ),
            loading: () =>
                const ListTile(title: Text('読み込み中...')),
            error: (_, __) => const ListTile(title: Text('エラー')),
          ),

          const SizedBox(height: 32),
          // ── DEBUGボタン（リリース前に削除） ──
          const Divider(),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () async {
              final repo = ref.read(entryRepositoryProvider);
              final now = DateTime.now();
              for (int i = 1; i <= 365; i++) {
                final date = now.subtract(Duration(days: i));
                final entry = MindEntry(
                  text: 'テストデータ $i 日前',
                  energy: (i % 5) + 1,
                  focus: ((i + 1) % 5) + 1,
                  fatigue: ((i + 2) % 5) + 1,
                  mood: ((i + 3) % 5) + 1,
                  sleepiness: ((i + 4) % 5) + 1,
                  createdAt: date,
                );
                await repo.save(entry);
              }
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('365日分のテストデータを追加しました')),
                );
              }
            },
            child: const Text('🧪 テストデータ365日追加'),
          ),
          // ── バージョン ──
          Center(
            child: Text(
              'MindCapsule v1.0.0',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
