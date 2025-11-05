import 'package:flutter/material.dart';
import 'dart:async';
import 'package:quiz_master/models/question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedOption;
  List<int?> userAnswers = [];
  int timeLeft = 29;
  Timer? timer;
  String userName = '';

  final List<Question> questions = [
    Question(
      question: 'What is the capital city of Australia?',
      options: ['Sydney', 'Canberra', 'Melbourne', 'Brisbane'],
      correctAnswer: 1,
    ),
    Question(
      question: 'Which programming language is used for Flutter?',
      options: ['Java', 'Kotlin', 'Dart', 'Swift'],
      correctAnswer: 2,
    ),
    Question(
      question: 'What does CSS stand for?',
      options: [
        'Computer Style Sheets',
        'Cascading Style Sheets',
        'Creative Style Sheets',
        'Colorful Style Sheets'
      ],
      correctAnswer: 1,
    ),
    Question(
      question: 'Which widget is used to display text in Flutter?',
      options: ['Container', 'Text', 'Label', 'TextView'],
      correctAnswer: 1,
    ),
    Question(
      question: 'What does API stand for?',
      options: [
        'Application Programming Interface',
        'Advanced Programming Interface',
        'Application Process Integration',
        'Advanced Process Interface'
      ],
      correctAnswer: 0,
    ),
    Question(
      question: 'Which JavaScript framework was developed by Facebook?',
      options: ['Angular', 'Vue', 'React', 'Svelte'],
      correctAnswer: 2,
    ),
    Question(
      question: 'What is Git used for?',
      options: [
        'Text editing',
        'Version control',
        'Database management',
        'Web server'
      ],
      correctAnswer: 1,
    ),
    Question(
      question: 'Which language is used for Android Native development?',
      options: ['Swift', 'Dart', 'Kotlin', 'C#'],
      correctAnswer: 2,
    ),
    Question(
      question: 'What does JSON stand for?',
      options: [
        'JavaScript Object Notation',
        'Java Standard Object Notation',
        'JavaScript Oriented Network',
        'Java Syntax Object Name'
      ],
      correctAnswer: 0,
    ),
    Question(
      question: 'Which database is open source?',
      options: ['Oracle', 'MySQL', 'SQL Server', 'DB2'],
      correctAnswer: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    userAnswers = List.filled(questions.length, null);
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userName = ModalRoute.of(context)?.settings.arguments as String? ?? 'User';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timeLeft = 29;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
          } else {
            nextQuestion();
          }
        });
      }
    });
  }

  void selectOption(int index) {
    setState(() {
      selectedOption = index;
      userAnswers[currentQuestionIndex] = index;
    });
  }

  void nextQuestion() {
    if (selectedOption == null) {
      userAnswers[currentQuestionIndex] = -1; // No answer
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOption = userAnswers[currentQuestionIndex];
      });
      startTimer();
    } else {
      timer?.cancel();
      Navigator.pushReplacementNamed(
        context,
        '/result',
        arguments: {
          'userName': userName,
          'userAnswers': userAnswers,
          'questions': questions,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4a4a6a),
              Color(0xFF2d2d44),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                SizedBox(height: size.height * 0.03),
                _buildProgressSection(currentQuestion),
                SizedBox(height: size.height * 0.03),
                Expanded(
                  child: _buildOptionsList(currentQuestion),
                ),
                SizedBox(height: size.height * 0.02),
                _buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Question ${currentQuestionIndex + 1}/10',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Text(
                '⏱',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                '$timeLeft',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(Question question) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${currentQuestionIndex + 1}/10',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList(Question question) {
    final letters = ['A', 'B', 'C', 'D'];

    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final isSelected = selectedOption == index;

        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: InkWell(
            onTap: () => selectOption(index),
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF3d3d5c),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFFffd93d) : Colors.transparent,
                  width: 2,
                ),
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF667eea),
                          Color(0xFF764ba2),
                        ],
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        letters[index],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? const Color(0xFF667eea)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      question.options[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Text(
                      '✓',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: selectedOption != null ? nextQuestion : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFffd93d),
        foregroundColor: const Color(0xFF2d2d44),
        disabledBackgroundColor: const Color(0xFF3d3d5c),
        disabledForegroundColor: Colors.white.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
      ),
      child: Text(
        currentQuestionIndex == questions.length - 1 ? 'Finish' : 'Next',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
