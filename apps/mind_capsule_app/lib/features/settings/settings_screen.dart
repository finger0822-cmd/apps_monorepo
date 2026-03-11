import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_provider.dart';

/// 設定画面：APIキー・言語・通知
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('APIキーを入力してください')),
        );
      }
      return;
    }
    setState(() => _isSavingKey = true);
    await ref.read(apiKeyAsyncProvider.notifier).save(key);
    if (mounted) {
      setState(() => _isSavingKey = false);
      _apiKeyController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('APIキーを保存しました')),
      );
    }
  }

  Future<void> _deleteApiKey() async {
    await ref.read(apiKeyAsyncProvider.notifier).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('APIキーを削除しました')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiKeyAsync = ref.watch(apiKeyAsyncProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Claude API キー
          Text(
            'Claude API キー',
            style: Theme.of(context).textTheme.titleMedium,
          ),
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
                      Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          display,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontFamily: 'monospace',
                              ),
                        ),
                      ),
                      TextButton(
                        onPressed: _deleteApiKey,
                        child: const Text('削除'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (e, st) => const SizedBox.shrink(),
          ),
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureApiKey,
            decoration: InputDecoration(
              hintText: 'sk-ant-...',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureApiKey ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => _obscureApiKey = !_obscureApiKey),
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('APIキーを保存'),
          ),
          const SizedBox(height: 24),
          // 言語
          Text(
            '言語',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          settingsAsync.when(
            data: (state) => SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ja', label: Text('日本語')),
                ButtonSegment(value: 'en', label: Text('English')),
              ],
              selected: {state.language},
              onSelectionChanged: (s) async {
                final v = s.first;
                await ref.read(settingsProvider.notifier).setLanguage(v);
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => const Text('読み込みエラー'),
          ),
          const SizedBox(height: 24),
          // 通知
          Text(
            '通知',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          settingsAsync.when(
            data: (state) => SwitchListTile(
              title: const Text('タイムカプセル開封通知'),
              subtitle: const Text('開封日に通知を送る'),
              value: state.notificationsEnabled,
              onChanged: (v) async {
                await ref.read(settingsProvider.notifier).setNotificationsEnabled(v);
              },
            ),
            loading: () => const ListTile(title: Text('読み込み中...')),
            error: (e, st) => const ListTile(title: Text('エラー')),
          ),
        ],
      ),
    );
  }
}
