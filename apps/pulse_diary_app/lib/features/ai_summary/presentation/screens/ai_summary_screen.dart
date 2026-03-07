import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pulse_diary_app/features/ai_feedback/presentation/providers/ai_feedback_provider.dart';

class AiSummaryScreen extends ConsumerWidget {
  const AiSummaryScreen({super.key, required this.entryId});

  final int entryId;

  static const _bg = Color(0xFF0F0F0F);
  static const _textColor = Color(0xFFEAEAEA);
  static const _subColor = Color(0xFF777777);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedbackAsync = ref.watch(aiFeedbackProvider((entryId, 'ja')));

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: feedbackAsync.when(
              loading: () => const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: _textColor),
                  SizedBox(height: 16),
                  Text(
                    'AIが読んでいます...',
                    style: TextStyle(color: _subColor, fontSize: 14),
                  ),
                ],
              ),
              data: (feedback) {
                if (feedback == null || feedback.isEmpty) {
                  return const Center(
                    child: Text(
                      '要約を取得できませんでした',
                      style: TextStyle(color: _subColor),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      feedback,
                      style: const TextStyle(
                        color: _textColor,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '✦',
                      style: TextStyle(
                        color: _subColor,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Align(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        child: const Text(
                          '完了',
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (err, stack) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      err.toString(),
                      style: const TextStyle(color: Color(0xFFE57373), fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(aiFeedbackProvider((entryId, 'ja')));
                      },
                      child: const Text(
                        'リトライ',
                        style: TextStyle(color: Color(0xFFEAEAEA)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
