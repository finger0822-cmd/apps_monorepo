import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entry/application/today_entry_controller.dart';
import '../../history/presentation/history_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(todayEntryControllerProvider);

    if (_controller.text != state.text) {
      _controller.value = TextEditingValue(
        text: state.text,
        selection: TextSelection.collapsed(offset: state.text.length),
      );
    }

    final todayLabel = DateFormat('yyyy.MM.dd').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '1分だけ書ける日記',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const HistoryScreen(),
                ),
              );
            },
            icon: const Icon(Icons.menu_book_outlined, color: Colors.white),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    todayLabel,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _controller,
                        readOnly: state.isReadOnly,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.6,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '今日は何を感じましたか',
                          hintStyle: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 22,
                          ),
                        ),
                        onChanged: (value) {
                          ref
                              .read(todayEntryControllerProvider.notifier)
                              .onTextChanged(value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _timerLabel(state),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFBDBDBD),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _timerLabel(TodayEntryState state) {
    if (state.hasSavedEntry) {
      return '保存済み';
    }
    if (!state.timerStarted) {
      return '入力で1分タイマー開始';
    }
    return '残り ${state.remainingSeconds} 秒';
  }
}
