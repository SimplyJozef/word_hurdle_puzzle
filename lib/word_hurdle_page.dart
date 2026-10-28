import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hurdle_provider.dart';
import 'wordle_view.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  // didChangeDependencies() sa môže zavolať viackrát (napr. pri otočení
  // obrazovky), preto hru inicializujeme len pri prvom volaní
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    // Získame inštanciu provideru a spustíme inicializáciu
    if (!_initialized) {
      Provider.of<HurdleProvider>(context, listen: false).init();
      _initialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Hurdle'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded zabezpečí, že GridView zaberie dostupný priestor
            Expanded(
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 5 stĺpcov = 5 písmen v riadku
                    mainAxisSpacing: 4, // vertikálne medzery
                    crossAxisSpacing: 4, // horizontálne medzery
                  ),
                  itemCount: provider.hurdleBoard.length,
                  itemBuilder: (context, index) {
                    // Každý prvok v mriežke = jeden objekt Wordle
                    final wordle = provider.hurdleBoard[index];
                    return WordleView(wordle: wordle);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
