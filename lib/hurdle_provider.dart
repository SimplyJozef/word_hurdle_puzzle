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

  int count = 0; // počet písmen v aktuálnom riadku
  int index = 0; // sleduje pozíciu v mriežke
  final int lettersPerRow = 5;

  bool wins = false;
  final int totalAttempts = 6;
  int attempts = 0;

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

  // ------------------------- KONTROLY (GETTERY) -------------------------
  bool get isValidWord => totalWords.contains(rowInputs.join('').toLowerCase());

  bool get shouldCheckForAnswer => rowInputs.length == lettersPerRow;

  bool get noAttemptsLeft => attempts == totalAttempts;

  // ------------------------- VSTUP A MAZANIE PÍSMEN -------------------------
  void inputLetter(String letter) {
    // po skončení hry sa už nedá písať (index by vyšiel mimo mriežky)
    if (wins || noAttemptsLeft) return;

    if (count < lettersPerRow) {
      // pridanie písmena do zoznamu aktuálneho vstupu
      rowInputs.add(letter);

      // vloženie písmena do príslušnej pozície v hernej doske
      hurdleBoard[index] = Wordle(letter: letter);

      // inkrementácia počítadiel
      count++;
      index++;

      // aktualizácia UI
      notifyListeners();
    }
  }

  void deleteLetter() {
    // odstránenie písmena z listu rowInputs
    if (rowInputs.isNotEmpty) {
      rowInputs.removeAt(rowInputs.length - 1);
    }

    // odstránenie písmena z hurdleBoard
    if (count > 0) {
      hurdleBoard[index - 1] = Wordle(letter: '');
      count--;
      index--;
    }
    notifyListeners(); // aktualizácia UI
  }

  // ------------------------- VYHODNOTENIE -------------------------
  void checkAnswer() {
    final input = rowInputs.join('');
    if (targetWord == input) {
      wins = true;
    } else {
      _markLettersOnBoard();
      if (attempts < totalAttempts) {
        _goToNextRow();
      }
    }
  }

  void _markLettersOnBoard() {
    for (int i = 0; i < hurdleBoard.length; i++) {
      if (hurdleBoard[i].letter.isNotEmpty &&
          targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].existsInTarget = true;
      } else if (hurdleBoard[i].letter.isNotEmpty &&
          !targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].doesNotExistInTarget = true;
        if (!excludedLetters.contains(hurdleBoard[i].letter)) {
          excludedLetters.add(hurdleBoard[i].letter);
        }
      }
    }
    notifyListeners();
  }

  void _goToNextRow() {
    attempts++;
    count = 0;
    rowInputs.clear();
  }

  // ------------------------- REŠTART HRY -------------------------
  void reset() {
    count = 0;
    index = 0;
    rowInputs.clear();
    hurdleBoard.clear();
    excludedLetters.clear();
    attempts = 0;
    wins = false;
    targetWord = '';
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }
}
