import 'package:flutter/material.dart';

import 'storage_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String _emptyText = 'まだ一文がありません';

  final StorageService _storageService = StorageService();
  final TextEditingController _controller = TextEditingController();

  String _currentSentence = _emptyText;
  bool _isFading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentSentence();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentSentence() async {
    final String? savedSentence = await _storageService.loadCurrentSentence();
    if (!mounted) {
      return;
    }

    setState(() {
      _currentSentence = (savedSentence == null || savedSentence.isEmpty)
          ? _emptyText
          : savedSentence;
    });
  }

  Future<void> _updateSentence() async {
    final String nextSentence = _controller.text.trim();
    if (nextSentence.isEmpty || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
      _isFading = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 220));
    await _storageService.saveCurrentSentence(nextSentence);

    if (!mounted) {
      return;
    }

    _controller.clear();
    setState(() {
      _currentSentence = nextSentence;
      _isFading = false;
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: AnimatedOpacity(
                      key: ValueKey<String>('$_currentSentence-$_isFading'),
                      opacity: _isFading ? 0 : 1,
                      duration: const Duration(milliseconds: 220),
                      child: Text(
                        _currentSentence,
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              TextField(
                controller: _controller,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _updateSentence(),
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: '今の自分を一文で入力',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white38),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _updateSentence,
                  child: const Text('更新する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
