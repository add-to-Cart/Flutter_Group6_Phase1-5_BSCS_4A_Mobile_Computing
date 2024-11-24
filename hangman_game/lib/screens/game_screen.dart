import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String category;
  final List<String> words;

  const GameScreen({Key? key, required this.category, required this.words})
      : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late String targetWord;
  late String hint;
  Set<String> guessedLetters = {};
  int lives = 6;

  // Animation variables
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    final random = Random();
    targetWord = widget.words[random.nextInt(widget.words.length)];
    hint = "Category: ${widget.category}. Word length: ${targetWord.length}";

    // Initialize animation
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

  void handleGuess(String letter) async {
    setState(() {
      if (!targetWord.contains(letter)) {
        lives--;
      } else {
        guessedLetters.add(letter);

        // Trigger bounce animation for correct guesses
        _controller.forward(from: 0);
      }
    });

    if (lives == 0) {
      showEndDialog("You Lost! The word was \"$targetWord\".");
    } else if (targetWord
        .split('')
        .every((char) => guessedLetters.contains(char))) {
      showEndDialog("Congratulations! You guessed the word!");
    }
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
              setState(() {
                guessedLetters = {};
                lives = 6;
              });
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
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
                child: Text(
                  guessedLetters.contains(char) ? char : "_",
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget buildAlphabetButtons() {
    const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      children: alphabet.split('').map((letter) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                guessedLetters.contains(letter) ? Colors.grey : Colors.blue,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
          onPressed: guessedLetters.contains(letter) || lives == 0
              ? null
              : () => handleGuess(letter),
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 14, // Smaller font size
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category: ${widget.category}"),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Swipe gestures
          if (details.velocity.pixelsPerSecond.dx > 0) {
            // Swipe right: Reset game
            setState(() {
              guessedLetters = {};
              lives = 6;
            });
          } else if (details.velocity.pixelsPerSecond.dx < 0) {
            // Swipe left: Return to home screen
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hint: $hint",
                style:
                    const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              Text(
                "Lives: $lives",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              FadeTransition(
                opacity: _controller.drive(CurveTween(curve: Curves.easeIn)),
                child: buildWordDisplay(),
              ),
              const SizedBox(height: 20),
              Expanded(child: buildAlphabetButtons()),
            ],
          ),
        ),
      ),
    );
  }
}
