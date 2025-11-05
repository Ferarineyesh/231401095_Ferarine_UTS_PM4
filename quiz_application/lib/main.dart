import 'package:flutter/material.dart';
import 'package:quiz_master/screens/welcome_screens.dart';
import 'package:quiz_master/screens/quiz_screens.dart';
import 'package:quiz_master/screens/result_screens.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/result': (context) => const ResultScreen(),
      },
    );
  }
}
