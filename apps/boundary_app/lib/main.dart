import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color _softWhite = Color(0xFFDDDDDD);

void main() {
  runApp(const BoundaryApp());
}

class BoundaryApp extends StatelessWidget {
  const BoundaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'boundary_app',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: _softWhite,
              displayColor: _softWhite,
            ),
      ),
      home: const BoundaryPage(),
    );
  }
}

class BoundaryPage extends StatefulWidget {
  const BoundaryPage({super.key});

  @override
  State<BoundaryPage> createState() => _BoundaryPageState();
}

class _BoundaryPageState extends State<BoundaryPage> {
  static const String _myKey = 'tasks_my';
  static const String _otherKey = 'tasks_other';
  static const String _pendingListKey = 'tasks_pending';
  static const String _legacyPendingKey = 'task_pending';
  static const String _draftKey = 'task_input_draft';
  static const int _maxItems = 20;
  static const double _centerResistanceThreshold = 8;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<TaskItem> _myTasks = <TaskItem>[];
  List<TaskItem> _otherTasks = <TaskItem>[];
  List<PendingTask> _pendingTasks = <PendingTask>[];
  String _draftInputText = '';
  final Map<String, double> _entryOffsets = <String, double>{};
  bool _isDraggingTask = false;
  bool _isNearCenterWhileDragging = false;

  RenderBox? _nearestRenderBox(BuildContext context) {
    RenderObject? object = context.findRenderObject();
    while (object != null && object is! RenderBox) {
      object = object.parent;
    }
    return object is RenderBox ? object : null;
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _setDragging(bool value) {
    if (_isDraggingTask == value) {
      return;
    }
    setState(() {
      _isDraggingTask = value;
      if (!value) {
        _isNearCenterWhileDragging = false;
      }
    });
  }

  void _updateCenterCrossingState(
    BuildContext context,
    Offset globalPosition,
    double centerY,
  ) {
    final RenderBox? box = _nearestRenderBox(context);
    if (box == null) {
      return;
    }
    final Offset local = box.globalToLocal(globalPosition);
    final bool nearCenter = (local.dy - centerY).abs() < 16;
    if (_isNearCenterWhileDragging != nearCenter) {
      setState(() {
        _isNearCenterWhileDragging = nearCenter;
      });
    }
  }

  void _trackEntryAnimation({
    required String taskId,
    required double startOffsetY,
  }) {
    _entryOffsets[taskId] = startOffsetY;
    Future<void>.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _entryOffsets.remove(taskId);
      });
    });
  }

  bool _passesCenterResistance(
    BuildContext context,
    Offset globalPosition,
    double centerY,
  ) {
    final RenderBox? box = _nearestRenderBox(context);
    if (box == null) {
      return true;
    }
    final double localY = box.globalToLocal(globalPosition).dy;
    return (localY - centerY).abs() > _centerResistanceThreshold;
  }

  Future<void> _loadTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<dynamic> myRaw =
        jsonDecode(prefs.getString(_myKey) ?? '[]') as List<dynamic>;
    final List<dynamic> otherRaw =
        jsonDecode(prefs.getString(_otherKey) ?? '[]') as List<dynamic>;
    final List<dynamic> pendingRaw =
        jsonDecode(prefs.getString(_pendingListKey) ?? '[]') as List<dynamic>;
    final String? legacyPendingRaw = prefs.getString(_legacyPendingKey);
    final String draftRaw = prefs.getString(_draftKey) ?? '';

    if (!mounted) {
      return;
    }

    final List<PendingTask> loadedPending = pendingRaw
        .map((dynamic e) => PendingTask.fromJson(e as Map<String, dynamic>))
        .toList();
    if (legacyPendingRaw != null && legacyPendingRaw.trim().isNotEmpty) {
      loadedPending.add(
        PendingTask(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: legacyPendingRaw.trim(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }

    setState(() {
      _myTasks = myRaw
          .map((dynamic e) => TaskItem.fromJson(e as Map<String, dynamic>))
          .toList();
      _otherTasks = otherRaw
          .map((dynamic e) => TaskItem.fromJson(e as Map<String, dynamic>))
          .toList();
      _pendingTasks = loadedPending;
      _draftInputText = draftRaw;
    });
    _controller.text = draftRaw;
    _controller.selection =
        TextSelection.collapsed(offset: _controller.text.length);
    if (legacyPendingRaw != null) {
      await prefs.remove(_legacyPendingKey);
    }
  }

  Future<void> _saveTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _myKey,
      jsonEncode(_myTasks.map((TaskItem e) => e.toJson()).toList()),
    );
    await prefs.setString(
      _otherKey,
      jsonEncode(_otherTasks.map((TaskItem e) => e.toJson()).toList()),
    );
    await prefs.setString(
      _pendingListKey,
      jsonEncode(_pendingTasks.map((PendingTask e) => e.toJson()).toList()),
    );
    await prefs.remove(_legacyPendingKey);
    await prefs.setString(_draftKey, _draftInputText);
  }

  Future<void> _submitTask() async {
    final String text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    final PendingTask item = PendingTask(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    setState(() {
      _pendingTasks = <PendingTask>[..._pendingTasks, item];
      if (_pendingTasks.length > _maxItems) {
        _pendingTasks = _pendingTasks.sublist(_pendingTasks.length - _maxItems);
      }
      _controller.clear();
      _draftInputText = '';
    });
    _focusNode.requestFocus();
    await _saveTasks();
  }

  Future<void> _classifyPendingTask({
    required String pendingId,
    required String bucket,
  }) async {
    PendingTask? pendingItem;
    for (final PendingTask item in _pendingTasks) {
      if (item.id == pendingId) {
        pendingItem = item;
        break;
      }
    }
    if (pendingItem == null) {
      return;
    }

    final TaskItem item = TaskItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: pendingItem.text,
      bucket: bucket,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      if (bucket == 'my') {
        _myTasks = <TaskItem>[..._myTasks, item];
        _trackEntryAnimation(taskId: item.id, startOffsetY: 0.2);
        if (_myTasks.length > _maxItems) {
          _myTasks = _myTasks.sublist(_myTasks.length - _maxItems);
        }
      } else {
        _otherTasks = <TaskItem>[..._otherTasks, item];
        _trackEntryAnimation(taskId: item.id, startOffsetY: -0.2);
        if (_otherTasks.length > _maxItems) {
          _otherTasks = _otherTasks.sublist(_otherTasks.length - _maxItems);
        }
      }
      _pendingTasks = _pendingTasks
          .where((PendingTask pending) => pending.id != pendingId)
          .toList();
    });
    await _saveTasks();
  }

  Future<void> _deleteTask(String bucket, String id) async {
    setState(() {
      if (bucket == 'my') {
        _myTasks = _myTasks.where((TaskItem item) => item.id != id).toList();
      } else if (bucket == 'other') {
        _otherTasks = _otherTasks.where((TaskItem item) => item.id != id).toList();
      } else {
        _pendingTasks =
            _pendingTasks.where((PendingTask pending) => pending.id != id).toList();
      }
    });
    await _saveTasks();
  }

  Future<void> _moveTaskToBucket({
    required String fromBucket,
    required String id,
    required String toBucket,
  }) async {
    if (fromBucket == 'pending') {
      await _classifyPendingTask(pendingId: id, bucket: toBucket);
      return;
    }

    if (fromBucket == toBucket) {
      return;
    }

    TaskItem? target;
    setState(() {
      if (fromBucket == 'my') {
        for (final TaskItem item in _myTasks) {
          if (item.id == id) {
            target = item;
            break;
          }
        }
        _myTasks = _myTasks.where((TaskItem item) => item.id != id).toList();
        if (target != null) {
          final TaskItem moved = target!.copyWith(bucket: toBucket);
          if (toBucket == 'my') {
            _myTasks = <TaskItem>[..._myTasks, moved];
            _trackEntryAnimation(taskId: moved.id, startOffsetY: 0.2);
            if (_myTasks.length > _maxItems) {
              _myTasks = _myTasks.sublist(_myTasks.length - _maxItems);
            }
          } else {
            _otherTasks = <TaskItem>[..._otherTasks, moved];
            _trackEntryAnimation(taskId: moved.id, startOffsetY: -0.2);
            if (_otherTasks.length > _maxItems) {
              _otherTasks = _otherTasks.sublist(_otherTasks.length - _maxItems);
            }
          }
        }
      } else {
        for (final TaskItem item in _otherTasks) {
          if (item.id == id) {
            target = item;
            break;
          }
        }
        _otherTasks = _otherTasks.where((TaskItem item) => item.id != id).toList();
        if (target != null) {
          final TaskItem moved = target!.copyWith(bucket: toBucket);
          if (toBucket == 'my') {
            _myTasks = <TaskItem>[..._myTasks, moved];
            _trackEntryAnimation(taskId: moved.id, startOffsetY: 0.2);
            if (_myTasks.length > _maxItems) {
              _myTasks = _myTasks.sublist(_myTasks.length - _maxItems);
            }
          } else {
            _otherTasks = <TaskItem>[..._otherTasks, moved];
            _trackEntryAnimation(taskId: moved.id, startOffsetY: -0.2);
            if (_otherTasks.length > _maxItems) {
              _otherTasks = _otherTasks.sublist(_otherTasks.length - _maxItems);
            }
          }
        }
      }
    });
    await _saveTasks();
  }

  Future<void> _clearAll() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121212),
          title: const Text('確認'),
          content: const Text('すべての課題を削除しますか？'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('削除'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    setState(() {
      _myTasks = <TaskItem>[];
      _otherTasks = <TaskItem>[];
      _pendingTasks = <PendingTask>[];
    });
    await _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double height = constraints.maxHeight;
            final double centerY = height / 2;
            final double centerGap = (height * 0.2).clamp(140.0, 190.0);
            final double centerGapHalf = centerGap / 2;

            final double topHeight =
                (centerY - centerGapHalf).clamp(100.0, height - 200.0);
            final double bottomTop =
                (centerY + centerGapHalf).clamp(topHeight + 80.0, height - 100.0);

            return Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: topHeight,
                  child: DragTarget<TaskDragData>(
                    onWillAcceptWithDetails:
                        (DragTargetDetails<TaskDragData> details) {
                      return details.data.fromBucket != 'my' &&
                          _passesCenterResistance(
                            context,
                            details.offset,
                            centerY,
                          );
                    },
                    onAcceptWithDetails:
                        (DragTargetDetails<TaskDragData> details) {
                      _moveTaskToBucket(
                        fromBucket: details.data.fromBucket,
                        id: details.data.id,
                        toBucket: 'my',
                      );
                    },
                    builder: (
                      BuildContext context,
                      List<TaskDragData?> candidateData,
                      List<dynamic> rejectedData,
                    ) {
                      final bool highlight = candidateData.any(
                        (TaskDragData? data) => data != null && data.fromBucket != 'my',
                      );
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          border: highlight
                              ? Border.all(color: Colors.white.withValues(alpha: 0.35))
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 8),
                            const Text(
                              '自分の課題',
                              style: TextStyle(
                                color: _softWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                itemCount: _myTasks.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final TaskItem item =
                                      _myTasks[_myTasks.length - 1 - index];
                                  final double entryOffset = _entryOffsets[item.id] ?? 0;
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: TweenAnimationBuilder<Offset>(
                                      duration: const Duration(milliseconds: 180),
                                      tween: Tween<Offset>(
                                        begin: Offset(0, entryOffset),
                                        end: Offset.zero,
                                      ),
                                      curve: Curves.easeOutCubic,
                                      builder: (
                                        BuildContext context,
                                        Offset offset,
                                        Widget? child,
                                      ) {
                                        return Transform.translate(
                                          offset: Offset(0, offset.dy * 20),
                                          child: AnimatedOpacity(
                                            duration: const Duration(milliseconds: 180),
                                            opacity: 1,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Draggable<TaskDragData>(
                                        data: TaskDragData(
                                          id: item.id,
                                          fromBucket: 'my',
                                        ),
                                        onDragStarted: () => _setDragging(true),
                                        onDragEnd: (_) => _setDragging(false),
                                        onDragCompleted: () => _setDragging(false),
                                        onDraggableCanceled:
                                            (Velocity velocity, Offset offset) =>
                                                _setDragging(false),
                                        onDragUpdate: (DragUpdateDetails details) {
                                          _updateCenterCrossingState(
                                            context,
                                            details.globalPosition,
                                            centerY,
                                          );
                                        },
                                        feedback: Material(
                                          color: Colors.transparent,
                                          child: TaskCard(text: item.text),
                                        ),
                                        childWhenDragging: Opacity(
                                          opacity: 0.35,
                                          child: TaskCard(text: item.text),
                                        ),
                                        child: TaskCard(text: item.text),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: bottomTop,
                  bottom: 0,
                  child: DragTarget<TaskDragData>(
                    onWillAcceptWithDetails:
                        (DragTargetDetails<TaskDragData> details) {
                      return details.data.fromBucket != 'other' &&
                          _passesCenterResistance(
                            context,
                            details.offset,
                            centerY,
                          );
                    },
                    onAcceptWithDetails:
                        (DragTargetDetails<TaskDragData> details) {
                      _moveTaskToBucket(
                        fromBucket: details.data.fromBucket,
                        id: details.data.id,
                        toBucket: 'other',
                      );
                    },
                    builder: (
                      BuildContext context,
                      List<TaskDragData?> candidateData,
                      List<dynamic> rejectedData,
                    ) {
                      final bool highlight = candidateData.any(
                        (TaskDragData? data) =>
                            data != null && data.fromBucket != 'other',
                      );
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          border: highlight
                              ? Border.all(color: Colors.white.withValues(alpha: 0.35))
                              : null,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 8),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.fromLTRB(12, 8, 12, 36),
                                itemCount: _otherTasks.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final TaskItem item =
                                      _otherTasks[_otherTasks.length - 1 - index];
                                  final double entryOffset = _entryOffsets[item.id] ?? 0;
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: TweenAnimationBuilder<Offset>(
                                      duration: const Duration(milliseconds: 180),
                                      tween: Tween<Offset>(
                                        begin: Offset(0, entryOffset),
                                        end: Offset.zero,
                                      ),
                                      curve: Curves.easeOutCubic,
                                      builder: (
                                        BuildContext context,
                                        Offset offset,
                                        Widget? child,
                                      ) {
                                        return Transform.translate(
                                          offset: Offset(0, offset.dy * 20),
                                          child: AnimatedOpacity(
                                            duration: const Duration(milliseconds: 180),
                                            opacity: 1,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: Draggable<TaskDragData>(
                                        data: TaskDragData(
                                          id: item.id,
                                          fromBucket: 'other',
                                        ),
                                        onDragStarted: () => _setDragging(true),
                                        onDragEnd: (_) => _setDragging(false),
                                        onDragCompleted: () => _setDragging(false),
                                        onDraggableCanceled:
                                            (Velocity velocity, Offset offset) =>
                                                _setDragging(false),
                                        onDragUpdate: (DragUpdateDetails details) {
                                          _updateCenterCrossingState(
                                            context,
                                            details.globalPosition,
                                            centerY,
                                          );
                                        },
                                        feedback: Material(
                                          color: Colors.transparent,
                                          child: TaskCard(text: item.text),
                                        ),
                                        childWhenDragging: Opacity(
                                          opacity: 0.35,
                                          child: TaskCard(text: item.text),
                                        ),
                                        child: TaskCard(text: item.text),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: BoundaryLinePainter(
                        y: centerY,
                        centerGapWidth: 420,
                        opacity: _isDraggingTask
                            ? (_isNearCenterWhileDragging ? 1 : 0.92)
                            : 0.78,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 8,
                  child: IgnorePointer(
                    child: Text(
                      '自分以外の人の課題',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _softWhite.withValues(alpha: 0.72),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 180),
                            switchInCurve: Curves.easeOut,
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                            child: _pendingTasks.isEmpty
                                ? Text(
                                    'ここに課題が表示されます',
                                    key: const ValueKey<String>('placeholder'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _softWhite.withValues(alpha: 0.4),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : ConstrainedBox(
                                    key: const ValueKey<String>('pending-list'),
                                    constraints: const BoxConstraints(maxHeight: 170),
                                    child: SingleChildScrollView(
                                      child: Wrap(
                                        spacing: 10,
                                        runSpacing: 8,
                                        alignment: WrapAlignment.center,
                                        children: _pendingTasks.reversed
                                            .map((PendingTask pending) {
                                          return Draggable<TaskDragData>(
                                            data: TaskDragData(
                                              id: pending.id,
                                              fromBucket: 'pending',
                                            ),
                                            onDragStarted: () => _setDragging(true),
                                            onDragEnd: (_) => _setDragging(false),
                                            onDragCompleted: () => _setDragging(false),
                                            onDraggableCanceled:
                                                (Velocity velocity, Offset offset) =>
                                                    _setDragging(false),
                                            onDragUpdate: (DragUpdateDetails details) {
                                              _updateCenterCrossingState(
                                                context,
                                                details.globalPosition,
                                                centerY,
                                              );
                                            },
                                            feedback: Material(
                                              color: Colors.transparent,
                                              child: TaskCard(text: pending.text),
                                            ),
                                            childWhenDragging: Opacity(
                                              opacity: 0.35,
                                              child: _CenterTaskText(text: pending.text),
                                            ),
                                            child: _CenterTaskText(text: pending.text),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            autofocus: true,
                            style: const TextStyle(color: _softWhite),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submitTask(),
                            onChanged: (String value) {
                              _draftInputText = value;
                              _saveTasks();
                            },
                            decoration: InputDecoration(
                              hintText: '課題を入力',
                              hintStyle: TextStyle(
                                color: _softWhite.withValues(alpha: 0.48),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white38, width: 0.8),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 1),
                              ),
                              isDense: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: DragTarget<TaskDragData>(
                    onAcceptWithDetails: (DragTargetDetails<TaskDragData> details) {
                      _deleteTask(details.data.fromBucket, details.data.id);
                    },
                    builder: (
                      BuildContext context,
                      List<TaskDragData?> candidateData,
                      List<dynamic> rejectedData,
                    ) {
                      final bool isActive = candidateData.isNotEmpty;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.white.withValues(alpha: 0.14) : null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: _clearAll,
                          icon: const Icon(Icons.delete_outline),
                          color: isActive ? Colors.white : _softWhite.withValues(alpha: 0.72),
                          tooltip: 'ここにドラッグで削除（タップで全削除）',
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TaskItem {
  const TaskItem({
    required this.id,
    required this.text,
    required this.bucket,
    required this.createdAt,
  });

  final String id;
  final String text;
  final String bucket;
  final int createdAt;

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String,
      text: json['text'] as String,
      bucket: json['bucket'] as String,
      createdAt: json['createdAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'bucket': bucket,
      'createdAt': createdAt,
    };
  }

  TaskItem copyWith({
    String? id,
    String? text,
    String? bucket,
    int? createdAt,
  }) {
    return TaskItem(
      id: id ?? this.id,
      text: text ?? this.text,
      bucket: bucket ?? this.bucket,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.78,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.22), width: 0.8),
        ),
        child: Text(
          text,
          softWrap: true,
          style: const TextStyle(color: _softWhite, fontSize: 13),
        ),
      ),
    );
  }
}

class _CenterTaskText extends StatelessWidget {
  const _CenterTaskText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: _softWhite.withValues(alpha: 0.9),
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class TaskDragData {
  const TaskDragData({
    required this.id,
    required this.fromBucket,
  });

  final String id;
  final String fromBucket;
}

class BoundaryLinePainter extends CustomPainter {
  const BoundaryLinePainter({
    required this.y,
    required this.centerGapWidth,
    required this.opacity,
  });

  final double y;
  final double centerGapWidth;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0))
      ..strokeWidth = 1;
    final double gapWidth = centerGapWidth.clamp(0, size.width);
    final double leftEnd = (size.width - gapWidth) / 2;
    final double rightStart = leftEnd + gapWidth;

    if (leftEnd > 0) {
      canvas.drawLine(Offset(0, y), Offset(leftEnd, y), paint);
    }
    if (rightStart < size.width) {
      canvas.drawLine(Offset(rightStart, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant BoundaryLinePainter oldDelegate) {
    return oldDelegate.y != y ||
        oldDelegate.centerGapWidth != centerGapWidth ||
        oldDelegate.opacity != opacity;
  }
}

class PendingTask {
  const PendingTask({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String text;
  final int createdAt;

  factory PendingTask.fromJson(Map<String, dynamic> json) {
    return PendingTask(
      id: json['id'] as String,
      text: json['text'] as String,
      createdAt: json['createdAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt,
    };
  }
}
