import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const OneSentenceApp());
}

class OneSentenceApp extends StatelessWidget {
  const OneSentenceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Sentence App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
