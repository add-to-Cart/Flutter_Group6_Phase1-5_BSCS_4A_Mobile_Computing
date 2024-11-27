import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hangman_game/screens/leaderboard_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCAwpWDMI5kEJRqqgqdqUDpuQ1scXsR-YU",
            authDomain: "grp6-hangman-flutter.firebaseapp.com",
            projectId: "grp6-hangman-flutter",
            storageBucket: "grp6-hangman-flutter.firebasestorage.app",
            messagingSenderId: "201509931140",
            appId: "1:201509931140:web:83e8448fa77f8486aedad1"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}
