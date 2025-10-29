// lib/main.dart
import 'package:flutter/material.dart';
import 'package:quiz_master/screens/welcome_screens.dart'; // Changed from quiz_application

void main() {
  runApp(const QuizMasterApp());
}

class QuizMasterApp extends StatelessWidget {
  const QuizMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizMaster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFF2d2d44),
      ),
      // Initial route
      initialRoute: '/',
      // Define all routes
      routes: {'/': (context) => const WelcomeScreen()},
    );
  }
}
