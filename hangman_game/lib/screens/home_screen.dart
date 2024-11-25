import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
        backgroundColor: Colors.pinkAccent.shade200,
        elevation: 12,
        shadowColor: Colors.pinkAccent.shade100,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade200, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Choose a Category",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: categories.keys.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          shadowColor: Colors.deepPurple.withOpacity(0.6),
                          elevation: 8,
                          side: BorderSide(
                            color: Colors.pink.shade100,
                            width: 2,
                          ),
                        ),
                        onPressed: () {
                          // Add scale effect using a simple animation controller or `InkWell`
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
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
