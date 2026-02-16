import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/storage/isar_service.dart';
import 'features/home/presentation/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isar = await IsarService.open();

  runApp(
    ProviderScope(
      overrides: <Override>[isarProvider.overrideWithValue(isar)],
      child: const OneMinuteDiaryApp(),
    ),
  );
}

class OneMinuteDiaryApp extends StatelessWidget {
  const OneMinuteDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '1分だけ書ける日記',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.light,
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyLarge: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                height: 1.5,
              ),
            ),
      ),
      home: const HomeScreen(),
    );
  }
}
