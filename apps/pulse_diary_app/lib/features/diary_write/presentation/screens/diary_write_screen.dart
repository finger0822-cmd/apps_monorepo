import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pulse_diary_app/core/storage/isar_service.dart';
import 'package:pulse_diary_app/domain/models/diary_entry.dart';
import 'package:pulse_diary_app/features/ai_summary/presentation/screens/ai_summary_screen.dart';

class DiaryWriteScreen extends ConsumerStatefulWidget {
  const DiaryWriteScreen({
    super.key,
    required this.energy,
    required this.focus,
    required this.fatigue,
    required this.mood,
    required this.sleepiness,
  });

  final int energy;
  final int focus;
  final int fatigue;
  final int mood;
  final int sleepiness;

  @override
  ConsumerState<DiaryWriteScreen> createState() => _DiaryWriteScreenState();
}

class _DiaryWriteScreenState extends ConsumerState<DiaryWriteScreen> {
  static const _bg = Color(0xFF0F0F0F);

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSave => _controller.text.trim().isNotEmpty;

  Future<void> _onSavePressed() async {
    if (!_canSave) return;

    final text = _controller.text.trim();
    final entry = DiaryEntry(
      text: text,
      energy: widget.energy,
      focus: widget.focus,
      fatigue: widget.fatigue,
      mood: widget.mood,
      sleepiness: widget.sleepiness,
      createdAt: DateTime.now(),
    );

    final isar = ref.read(isarProvider);
    await isar.writeTxn(() async {
      await isar.diaryEntrys.put(entry);
    });

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => AiSummaryScreen(entryId: entry.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _controller,
                    onChanged: (_) => setState(() {}),
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: '今日はどんな一日でしたか？',
                      hintStyle: TextStyle(color: Color(0xFF555555)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      color: Color(0xFFEAEAEA),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 24),
                  child: GestureDetector(
                    onTap: _canSave ? _onSavePressed : null,
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 120),
                      opacity: _canSave ? 0.75 : 0.25,
                      child: const Text(
                        '記録 →',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFEAEAEA),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
