import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/app_providers.dart';
import '../settings/settings_provider.dart';
import '../../domain/models/mind_entry.dart';
/// タイムカプセル開封画面。過去のメッセージと AI 比較分析を表示
class CapsuleOpenScreen extends ConsumerStatefulWidget {
  const CapsuleOpenScreen({super.key, required this.entryId});

  final int entryId;

  @override
  ConsumerState<CapsuleOpenScreen> createState() => _CapsuleOpenScreenState();
}

class _CapsuleOpenScreenState extends ConsumerState<CapsuleOpenScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animOpacity;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(entryRepositoryProvider);
    final lang = ref.watch(appLanguageProvider);
    final dateFormat = DateFormat('yyyy/MM/dd');

    return FutureBuilder<MindEntry?>(
      future: repo.getById(widget.entryId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('開封')),
            body: snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : const Center(child: Text('見つかりません')),
          );
        }
        final entry = snapshot.data!;
        final isSealed = entry.isSealed &&
            entry.openOn != null &&
            entry.openOn!.isAfter(DateTime.now());

        if (isSealed) {
          return Scaffold(
            appBar: AppBar(title: const Text('タイムカプセル')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🔒', style: TextStyle(fontSize: 72)),
                    const SizedBox(height: 24),
                    Text(
                      '封印中',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6A3DE8),
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '開封日: ${dateFormat.format(entry.openOn!)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'あと ${entry.openOn!.difference(DateTime.now()).inDays + 1} 日後に開封できます',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${dateFormat.format(entry.createdAt)} の自分から'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: FadeTransition(
              opacity: _animOpacity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 開封アニメーション風のアイコン
                  Center(
                    child: Icon(
                      Icons.mail_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '過去の自分のメッセージ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (entry.capsuleNote != null &&
                      entry.capsuleNote!.trim().isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        entry.capsuleNote!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Text(
                    entry.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'AI 比較分析（過去の自分 → 今の自分）',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  _AiComparisonSection(entryId: entry.id, language: lang),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// AI 比較分析を非同期で取得して表示するウィジェット
class _AiComparisonSection extends ConsumerStatefulWidget {
  const _AiComparisonSection({
    required this.entryId,
    required this.language,
  });

  final int entryId;
  final String language;

  @override
  ConsumerState<_AiComparisonSection> createState() =>
      _AiComparisonSectionState();
}

class _AiComparisonSectionState extends ConsumerState<_AiComparisonSection> {
  String? _comparison;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(entryRepositoryProvider);
    final result =
        await repo.fetchAiComparison(widget.entryId, widget.language);
    if (!mounted) return;
    setState(() {
      _comparison = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_comparison != null && _comparison!.isNotEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _comparison!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
      );
    }
    return Text(
      'APIキーを設定すると比較分析が表示されます。',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}
