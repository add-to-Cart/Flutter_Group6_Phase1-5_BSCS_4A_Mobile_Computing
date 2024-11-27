import 'package:flutter_test/flutter_test.dart';
import 'package:hangman_game/screens/game_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Check word selection display', (WidgetTester tester) async {
    // Sample words for testing
    var words = ["CAT", "DOG", "ELEPHANT"];

    // Build the GameScreen widget
    await tester.pumpWidget(MaterialApp(
      home: GameScreen(
        category: "Animals",
        words: words,
        playerName: '',
      ),
    ));

    // Wait for the widget to finish building
    await tester.pumpAndSettle();

    // Check if the word display contains underscores for each letter in the word
    expect(find.text("_"), findsWidgets);
    expect(find.text("CAT"),
        findsNothing); // The word should not be fully visible at the start
  });
}
