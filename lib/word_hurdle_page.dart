import 'package:flutter/material.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Hurdle'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to Word Hurdle!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
