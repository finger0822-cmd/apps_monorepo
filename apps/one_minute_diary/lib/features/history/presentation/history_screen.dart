import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entry/data/entry_repository.dart';
import '../../entry/domain/entry.dart';
import 'entry_view_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _selectedDay = DateTime.now();

  DateTime _toDateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  String _dateKey(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(allEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('履歴')),
      body: entriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (error, stackTrace) => const Center(
          child: Text(
            '履歴の読み込みに失敗しました。',
            style: TextStyle(color: Colors.white),
          ),
        ),
        data: (entries) {
          final Map<String, Entry> entryByDate = <String, Entry>{
            for (final entry in entries) entry.date: entry,
          };

          final DateTime today = _toDateOnly(DateTime.now());
          final DateTime firstDate = DateTime(2000, 1, 1);
          final DateTime lastDate = today;

          final DateTime initialDate = _selectedDay.isBefore(firstDate)
              ? firstDate
              : (_selectedDay.isAfter(lastDate) ? lastDate : _selectedDay);
          final String selectedKey = _dateKey(_selectedDay);
          final Entry? selectedEntry = entryByDate[selectedKey];
          final List<int> daysWithEntryInMonth = entries
              .map((entry) => DateTime.tryParse(entry.date))
              .whereType<DateTime>()
              .where(
                (day) =>
                    day.year == _selectedDay.year && day.month == _selectedDay.month,
              )
              .map((day) => day.day)
              .toList()
            ..sort();
          final String monthEntryText = daysWithEntryInMonth.isEmpty
              ? '今月の記録日はありません。'
              : '今月の記録日: ${daysWithEntryInMonth.join(' / ')}日';

          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: CalendarDatePicker(
                  initialDate: initialDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onDateChanged: (day) {
                    setState(() {
                      _selectedDay = _toDateOnly(day);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    selectedEntry == null
                        ? 'この日の記録はありません'
                        : 'この日は記録があります',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          selectedEntry == null ? const Color(0xFFBDBDBD) : Colors.lightGreenAccent,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    monthEntryText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1, color: Colors.white24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: selectedEntry == null
                      ? const Center(
                          child: Text(
                            'この日の記録はありません。',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFBDBDBD),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              selectedEntry.date,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _firstLine(selectedEntry.text),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFFBDBDBD),
                              ),
                            ),
                            const SizedBox(height: 14),
                            OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        EntryViewScreen(entryId: selectedEntry.id),
                                  ),
                                );
                              },
                              child: const Text('全文を開く'),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _firstLine(String text) {
    final lines = text.split('\n');
    if (lines.isEmpty) {
      return '';
    }
    return lines.first.trim();
  }
}
