import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pulse_app/core/errors/result.dart';
import 'package:pulse_app/core/theme/app_theme.dart';
import 'package:pulse_app/features/pulse/application/providers/pulse_providers.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/value_objects/local_date.dart';

/// AI インサイト表示・生成画面。
class InsightsPage extends ConsumerStatefulWidget {
  const InsightsPage({super.key});

  @override
  ConsumerState<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends ConsumerState<InsightsPage> {
  static List<LocalDate> _last7Days() {
    final now = DateTime.now().toUtc();
    final today = LocalDate.fromDateTime(now);
    return List.generate(7, (i) {
      final dt = DateTime.utc(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - i));
      return LocalDate.fromDateTime(dt);
    });
  }

  Insight? _insight;
  String? _error;
  bool _loading = false;

  Future<void> _loadLatest() async {
    final repo = ref.read(insightRepositoryProvider);
    final scope = _last7Days();
    if (scope.isEmpty) return;
    final start = scope.first;
    final end = scope.last;
    final list = await repo.list(start, end);
    if (!mounted) return;
    setState(() {
      _insight = list.isNotEmpty ? list.first : null;
      _error = null;
    });
  }

  Future<void> _onGenerate() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    const userId = 'default';
    final usecase = ref.read(generateInsightsUsecaseProvider);
    final result = await usecase.execute(userId: userId);
    if (!mounted) return;
    setState(() {
      _loading = false;
      result.when(
        success: (insight) {
          _insight = insight;
          _error = null;
        },
        failure: (msg) {
          _error = msg;
        },
      );
    });
    if (result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('インサイトを生成しました'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.when(success: (_) => '', failure: (e) => e)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLatest());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('AI インサイト'),
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.textMain,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loading ? null : _onGenerate,
                  icon: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome),
                  label: Text(_loading ? '生成中...' : 'インサイトを生成'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(color: theme.colorScheme.onErrorContainer),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Expanded(
                  child: _insight == null
                      ? Center(
                          child: Text(
                            '「インサイトを生成」をタップして、直近7日分のログから傾向を分析します。',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: _InsightContent(insight: _insight!),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightContent extends StatelessWidget {
  const _InsightContent({required this.insight});

  final Insight insight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          insight.summaryText,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppTheme.textMain,
            height: 1.5,
          ),
        ),
        if (insight.bulletPoints != null &&
            insight.bulletPoints!.isNotEmpty) ...[
          const SizedBox(height: 20),
          ..._parseDetails(insight.bulletPoints!),
        ],
      ],
    );
  }

  static List<Widget> _parseDetails(String detailsJson) {
    try {
      final list = jsonDecode(detailsJson) as List<dynamic>?;
      if (list == null || list.isEmpty) return [];
      return list.map((e) {
        final map = e as Map<String, dynamic>?;
        if (map == null) return const SizedBox.shrink();
        final title = map['title'] as String? ?? '';
        final body = map['body'] as String? ?? '';
        if (title.isEmpty && body.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty)
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMain,
                    fontSize: 15,
                  ),
                ),
              if (title.isNotEmpty) const SizedBox(height: 4),
              if (body.isNotEmpty)
                Text(
                  body,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
            ],
          ),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }
}
