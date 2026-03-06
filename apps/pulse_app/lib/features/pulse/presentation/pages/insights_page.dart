import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pulse_app/core/result.dart';
import 'package:pulse_app/features/pulse/application/usecases/generate_insights_usecase.dart';
import 'package:pulse_app/features/pulse/domain/entities/insight.dart';
import 'package:pulse_app/features/pulse/domain/repositories/insight_repository.dart';

/// Insights list and generate. Depends on [GenerateInsightsUsecase] and [InsightRepository] (injected).
class InsightsPage extends StatefulWidget {
  const InsightsPage({
    super.key,
    required this.generateUsecase,
    required this.insightRepo,
    this.userId = 'default',
    this.rangeKey = 'weekly',
  });

  final GenerateInsightsUsecase generateUsecase;
  final InsightRepository insightRepo;
  final String userId;
  final String rangeKey;

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  List<Insight> _insights = [];
  String? _error;
  bool _loading = false;
  bool _generateLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    final result = await widget.insightRepo.listByRangeKey(widget.userId, widget.rangeKey);
    if (!mounted) return;
    setState(() {
      _loading = false;
      switch (result) {
        case Ok(value: final list):
          _insights = list;
          _error = null;
        case Err(:final error):
          _error = error.message;
          _insights = [];
      }
    });
  }

  Future<void> _onGenerate() async {
    setState(() {
      _error = null;
      _generateLoading = true;
    });
    final now = DateTime.now().toUtc();
    final start = now.subtract(const Duration(days: 7));
    final formatter = DateFormat('yyyy-MM-dd');
    final startStr = formatter.format(start);
    final endStr = formatter.format(now);
    final result = await widget.generateUsecase.execute(
      userId: widget.userId,
      rangeKey: widget.rangeKey,
      startLocalDateInclusive: startStr,
      endLocalDateInclusive: endStr,
    );
    if (!mounted) return;
    setState(() {
      _generateLoading = false;
      switch (result) {
        case Ok(value: final insight):
          _insights = [insight, ..._insights];
          _error = null;
        case Err(:final error):
          _error = error.message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        actions: [
          if (_generateLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _onGenerate,
              child: const Text('Generate'),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _load(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (_insights.isEmpty) {
      return const Center(child: Text('No insights. Tap Generate.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _insights.length,
      itemBuilder: (context, index) {
        final i = _insights[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  i.summaryText,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (i.bullets.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...i.bullets.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text('• $b', style: Theme.of(context).textTheme.bodyMedium),
                      )),
                ],
                const SizedBox(height: 8),
                Text(
                  '${i.model} v${i.promptVersion} · ${DateFormat('yyyy-MM-dd HH:mm').format(i.createdAtUtc)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
