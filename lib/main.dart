import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Hurdle Puzzle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark, // tmavší kontrast
        ),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(), // inicializuje načítavanie
      home: const Placeholder(),   // dočasný widget
    );
  }
}
