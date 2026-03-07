import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

const _bg = Color(0xFF0F0F0F);
const _text = Color(0xFFEAEAEA);
const _sub = Color(0xFF777777);
const _border = Color(0xFF2A2A2A);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _obscureText = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _border,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _onSave() async {
    final key = _controller.text.trim();
    if (key.isEmpty) {
      _showSnackBar('APIキーを入力してください');
      return;
    }
    setState(() => _isSaving = true);
    await ref.read(apiKeyNotifierProvider.notifier).save(key);
    if (mounted) {
      setState(() => _isSaving = false);
      _controller.clear();
      _showSnackBar('APIキーを保存しました');
    }
  }

  Future<void> _onDelete() async {
    await ref.read(apiKeyNotifierProvider.notifier).delete();
    if (mounted) _showSnackBar('APIキーを削除しました');
  }

  @override
  Widget build(BuildContext context) {
    final apiKeyAsync = ref.watch(apiKeyNotifierProvider);

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: _text, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            '設定',
            style: TextStyle(color: _text, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Claude API キー
                const Text(
                  'Claude API キー',
                  style: TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                apiKeyAsync.when(
                  data: (key) {
                    if (key != null && key.isNotEmpty) {
                      final display = key.length > 20 ? '${key.substring(0, 20)}...' : key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                display,
                                style: const TextStyle(
                                  color: _sub,
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _onDelete,
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 120),
                                opacity: 1,
                                child: const Text(
                                  '削除',
                                  style: TextStyle(color: _sub, fontSize: 14),
                                ),
                              ),
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: _border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    obscureText: _obscureText,
                    style: const TextStyle(color: _text, fontFamily: 'monospace', fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'sk-ant-api03-...',
                      hintStyle: const TextStyle(color: _sub, fontFamily: 'monospace'),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: _sub,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: _isSaving ? null : _onSave,
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 120),
                    opacity: _isSaving ? 0.5 : 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _border,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: _text),
                            )
                          : const Text(
                              '保存',
                              style: TextStyle(color: _text, fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // APIキーの取得方法
                const Text(
                  'APIキーの取得方法',
                  style: TextStyle(
                    color: _text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Anthropic のコンソール（console.anthropic.com）にログインし、API Keys からキーを発行できます。'
                  '発行したキーを上記の欄に入力して保存すると、日記のAIフィードバック機能で利用されます。',
                  style: TextStyle(color: _sub, fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
