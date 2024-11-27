import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  final String category;
  final List<String> words;
  final String playerName;

  const GameScreen(
      {super.key,
      required this.category,
      required this.words,
      required this.playerName});

  Object? get targetWord => null;

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late String targetWord;
  late String hint;
  Set<String> guessedLetters = {};
  int lives = 6;
  int score = 0;

  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    final random = Random();
    targetWord = widget.words[random.nextInt(widget.words.length)];
    hint = "Category: ${widget.category}. Word length: ${targetWord.length}";

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleGuess(String letter) {
    if (guessedLetters.contains(letter) || lives == 0) return;

    setState(() {
      guessedLetters.add(letter);
      if (!targetWord.contains(letter)) {
        lives--;
      } else {
        _controller.forward(from: 0);
        score += 10; // Increment score for correct guesses
      }
    });

    if (lives == 0) {
      saveScore("Lost");
      showEndDialog("You Lost! The word was \"$targetWord\".");
    } else if (targetWord
        .split('')
        .every((char) => guessedLetters.contains(char))) {
      saveScore("Won");
      showEndDialog("Congratulations! You guessed the word!");
    }
  }

  Future<void> saveScore(String result) async {
    await _firestore.collection('leaderboard').add({
      'playerName': widget.playerName,
      'category': widget.category,
      'score': score,
      'result': result,
      'date': DateTime.now(),
    });
  }

  void showEndDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Home"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      final random = Random();
      targetWord = widget.words[random.nextInt(widget.words.length)];
      guessedLetters.clear();
      lives = 6;
    });
  }

  Widget buildWordDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: targetWord.split('').map((char) {
        return AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: guessedLetters.contains(char) ? _bounceAnimation.value : 1,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  guessedLetters.contains(char) ? char : "_",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildAlphabetButtons() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: 26,
      itemBuilder: (context, index) {
        String letter = String.fromCharCode(65 + index);

        return GestureDetector(
          onTap: () =>
              guessedLetters.contains(letter) ? null : handleGuess(letter),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: guessedLetters.contains(letter)
                  ? LinearGradient(
                      colors: [Colors.grey.shade400, Colors.grey.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : LinearGradient(
                      colors: [Colors.teal.shade300, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: guessedLetters.contains(letter)
                  ? []
                  : [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(2, 4),
                      ),
                    ],
            ),
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 18,
                color: guessedLetters.contains(letter)
                    ? Colors.white.withOpacity(0.6)
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category: ${widget.category}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 10,
        shadowColor: Colors.black45,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                hint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                lives,
                (index) =>
                    const Icon(Icons.favorite, color: Colors.red, size: 30),
              ),
            ),
            const SizedBox(height: 20),
            buildWordDisplay(),
            const Spacer(),
            Expanded(
              flex: 3,
              child: buildAlphabetButtons(),
            ),
          ],
        ),
      ),
    );
  }
}
