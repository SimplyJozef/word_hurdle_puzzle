import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart' as words; // import s aliasom
import 'wordle.dart';

class HurdleProvider extends ChangeNotifier {
  // Generátor náhodných čísel (pre výber cieľového slova)
  final random = Random.secure();

  // Zoznam všetkých slov dĺžky 5 znakov
  List<String> totalWords = [];

  // Dočasné vstupy používateľa (aktuálny riadok v mriežke)
  List<String> rowInputs = [];

  // Zoznam vyradených písmen (písmená, ktoré nie sú v cieľovom slove)
  List<String> excludedLetters = [];

  // Herný panel – obsahuje 30 prvkov typu Wordle (6 riadkov × 5 písmen)
  List<Wordle> hurdleBoard = [];

  // Cieľové (náhodne vybrané) slovo
  String targetWord = '';

  void init() {
    // Získame všetky slová z balíčka english_words a vyfiltrujeme len tie, ktoré majú 5 znakov
    totalWords = words.all.where((element) => element.length == 5).toList();

    // Vygenerujeme herný panel (30 prázdnych políčok)
    generateBoard();

    // Vyberieme náhodné cieľové slovo
    generateRandomWord();
  }

  // ------------------------- GENEROVANIE MRIEŽKY -------------------------
  void generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ''));
  }

  // ------------------------- GENEROVANIE CIEĽOVÉHO SLOVA -------------------------
  void generateRandomWord() {
    // Získame cieľové slovo a uložíme ho vo veľkých písmenách
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
    print(targetWord);
  }
}
