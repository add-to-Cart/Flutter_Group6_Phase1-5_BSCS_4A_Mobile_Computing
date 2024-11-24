import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = {
      "Animals": ["CAT", "DOG", "ELEPHANT", "TIGER", "ZEBRA", "LION"],
      "Fruits": ["APPLE", "BANANA", "CHERRY", "ORANGE", "MANGO"],
      "Countries": ["INDIA", "CANADA", "BRAZIL", "JAPAN", "FRANCE"]
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hangman Game"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose a Category",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: categories.keys.map((category) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameScreen(
                            category: category,
                            words: categories[category]!,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      category,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
