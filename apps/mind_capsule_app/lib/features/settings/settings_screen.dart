import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/providers/app_providers.dart';
import '../../core/services/subscription_service.dart';
import '../../domain/models/mind_entry.dart';
import '../paywall/paywall_screen.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  /// モーダルで PaywallScreen を表示する
  void _showPaywall(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.9,
        child: const PaywallScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final lang = ref.watch(appLanguageProvider);
    final s = AppStrings.of(lang);

    return Scaffold(
      appBar: AppBar(title: Text(s.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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

          const SizedBox(height: 24),

          // ── サブスクリプション ──
          Text(s.subscription,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ref.watch(subscriptionProvider).when(
            data: (state) {
              if (state.isPremium) {
                return ListTile(
                  leading: const Icon(Icons.workspace_premium,
                      color: Colors.amber),
                  title: Text(s.premiumMember),
                  subtitle: Text(s.premiumSubtitle),
                );
              }
              return ListTile(
                leading: const Icon(Icons.star_outline),
                title: Text(s.premiumUpgrade),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showPaywall(context),
              );
            },
            loading: () => ListTile(title: Text(s.loading)),
            error: (_, __) => ListTile(title: Text(s.error)),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(s.restorePurchase),
            onTap: () async {
              try {
                await ref.read(subscriptionProvider.notifier).restorePurchases();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.restorePurchaseDone)),
                  );
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(s.errorOccurred)),
                  );
                }
              }
            },
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
                  SnackBar(content: Text(s.testData365DaysAdded)),
                );
              }
            },
            child: Text(s.testData365DaysButton),
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
