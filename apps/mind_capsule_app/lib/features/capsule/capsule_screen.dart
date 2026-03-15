import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/app_providers.dart';
import '../../domain/models/mind_entry.dart';
import 'capsule_open_screen.dart';
import 'capsule_provider.dart';

class CapsuleScreen extends ConsumerStatefulWidget {
  const CapsuleScreen({super.key});

  @override
  ConsumerState<CapsuleScreen> createState() => _CapsuleScreenState();
}

class _CapsuleScreenState extends ConsumerState<CapsuleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onCapsuleTap(BuildContext context, MindEntry entry) async {
    final now = DateTime.now();
    if (entry.isSealed && entry.openOn != null && !entry.openOn!.isAfter(now)) {
      final repo = ref.read(entryRepositoryProvider);
      await repo.openDueCapsules();
      ref.invalidate(sealedCapsulesProvider);
      ref.invalidate(openedCapsulesProvider);
      if (!context.mounted) return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CapsuleOpenScreen(entryId: entry.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'タイムカプセル',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6A3DE8),
          labelColor: const Color(0xFF6A3DE8),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: '開封待ち'),
            Tab(text: '受け取り済み'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CapsuleList(
            provider: sealedCapsulesProvider,
            isSealed: true,
            onTap: _onCapsuleTap,
            emptyMessage: '開封待ちのカプセルはありません',
            emptySubMessage: '記録画面でタイムカプセルとして\n送ると届きます',
          ),
          _CapsuleList(
            provider: openedCapsulesProvider,
            isSealed: false,
            onTap: _onCapsuleTap,
            emptyMessage: '受け取り済みのカプセルはありません',
            emptySubMessage: '開封日になると自動で移動されます',
          ),
        ],
      ),
    );
  }
}

class _CapsuleList extends ConsumerWidget {
  const _CapsuleList({
    required this.provider,
    required this.isSealed,
    required this.onTap,
    required this.emptyMessage,
    required this.emptySubMessage,
  });

  final FutureProvider<List<MindEntry>> provider;
  final bool isSealed;
  final void Function(BuildContext context, MindEntry entry) onTap;
  final String emptyMessage;
  final String emptySubMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(
        child: Text('エラー: $e', style: Theme.of(context).textTheme.bodySmall),
      ),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🕰️', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  Text(
                    emptyMessage,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    emptySubMessage,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: list.length,
          itemBuilder: (context, i) {
            final entry = list[i];
            return _CapsuleCard(
              entry: entry,
              isSealed: isSealed,
              onTap: () => onTap(context, entry),
            );
          },
        );
      },
    );
  }
}

class _CapsuleCard extends StatelessWidget {
  const _CapsuleCard({
    required this.entry,
    required this.isSealed,
    required this.onTap,
  });

  final MindEntry entry;
  final bool isSealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    final openOnStr = entry.openOn != null
        ? dateFormat.format(entry.openOn!)
        : '-';
    int? daysLeft;
    if (isSealed && entry.openOn != null) {
      final now = DateTime.now();
      final openOn = entry.openOn!;
      final today = DateTime(now.year, now.month, now.day);
      final openDay = DateTime(openOn.year, openOn.month, openOn.day);
      daysLeft = openDay.difference(today).inDays;
    }
    final diaryPreview = entry.text.split('\n').first.trim();
    final diaryLine = diaryPreview.length > 50
        ? '${diaryPreview.substring(0, 50)}...'
        : diaryPreview;

    final bool isUrgent = daysLeft != null && daysLeft <= 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: Colors.black12,
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 左：アイコン
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('🕰️', style: TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(width: 14),
              // 右：情報
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          openOnStr,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                        const Spacer(),
                        if (!isSealed)
                          const Text('✅', style: TextStyle(fontSize: 16)),
                        if (entry.aiComparison != null &&
                            entry.aiComparison!.isNotEmpty) ...[
                          const SizedBox(width: 4),
                          const Text('✨', style: TextStyle(fontSize: 14)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSealed && daysLeft != null
                          ? (daysLeft <= 0
                                ? '🎉 開封日です！'
                                : daysLeft == 1
                                ? '⏰ あと 1 日'
                                : 'あと $daysLeft 日')
                          : '開封済み',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isUrgent
                            ? const Color(0xFFE57373)
                            : const Color(0xFF6A3DE8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSealed
                          ? '🔒 封印中'
                          : (diaryLine.isEmpty ? '(日記なし)' : diaryLine),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSealed ? const Color(0xFF9C6FE4) : Colors.grey,
                        fontWeight: isSealed
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
