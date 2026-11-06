import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:word_hurdle_puzzle/hurdle_provider.dart';
import 'package:word_hurdle_puzzle/main.dart';

// Vloží slovo písmeno po písmene, ako keby ho hráč naťukal na klávesnici
void typeWord(HurdleProvider provider, String word) {
  for (final letter in word.split('')) {
    provider.inputLetter(letter);
  }
}

// Vráti platné 5-písmenové slovo, ktoré nie je cieľovým slovom
String wrongWord(HurdleProvider provider) => provider.totalWords
    .map((w) => w.toUpperCase())
    .firstWhere((w) => w != provider.targetWord);

void main() {
  testWidgets('aplikácia zobrazí mriežku, klávesnicu a tlačidlá',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => HurdleProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Word Hurdle'), findsOneWidget);
    expect(find.text('DELETE'), findsOneWidget);
    expect(find.text('SUBMIT'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Q'), findsOneWidget);
  });

  test('najviac 5 písmen v riadku a DELETE maže posledné', () {
    final provider = HurdleProvider()..init();
    typeWord(provider, 'ABCDEFG');
    expect(provider.rowInputs, ['A', 'B', 'C', 'D', 'E']);

    provider.deleteLetter();
    expect(provider.rowInputs, ['A', 'B', 'C', 'D']);
    expect(provider.hurdleBoard[4].letter, '');
  });

  test('uhádnuté slovo nastaví wins = true', () {
    final provider = HurdleProvider()..init();
    typeWord(provider, provider.targetWord);
    expect(provider.isValidWord, isTrue);
    provider.checkAnswer();
    expect(provider.wins, isTrue);
  });

  test('6 nesprávnych pokusov = prehra, reset spustí novú hru', () {
    final provider = HurdleProvider()..init();
    for (int i = 0; i < provider.totalAttempts; i++) {
      typeWord(provider, wrongWord(provider));
      provider.checkAnswer();
    }
    expect(provider.wins, isFalse);
    expect(provider.noAttemptsLeft, isTrue);

    // po prehre sa už nedá písať
    provider.inputLetter('A');
    expect(provider.rowInputs, isEmpty);

    provider.reset();
    expect(provider.attempts, 0);
    expect(provider.excludedLetters, isEmpty);
    expect(provider.hurdleBoard.every((w) => w.letter.isEmpty), isTrue);
    expect(provider.targetWord.length, 5);
  });
}
