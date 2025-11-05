import 'package:flutter/material.dart';
import 'package:quiz_master/models/question.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  String userName = '';
  int correctAnswers = 0;
  int wrongAnswers = 0;
  int score = 0;
  int totalQuestions = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      userName = args['userName'] ?? 'User';
      final List<int?> userAnswers = args['userAnswers'] ?? [];
      final List<Question> questions = args['questions'] ?? [];

      totalQuestions = questions.length;
      correctAnswers = 0;

      for (int i = 0; i < userAnswers.length; i++) {
        if (userAnswers[i] == questions[i].correctAnswer) {
          correctAnswers++;
        }
      }

      wrongAnswers = totalQuestions - correctAnswers;
      score = ((correctAnswers / totalQuestions) * 100).round();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _retakeQuiz() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    final isVerySmallScreen = size.height < 600;

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCongratulationsSection(
                            size, isSmallScreen, isVerySmallScreen),
                        SizedBox(
                            height: isVerySmallScreen
                                ? 12
                                : (isSmallScreen ? 16 : 20)),
                        _buildScoreCircle(isSmallScreen, isVerySmallScreen),
                        SizedBox(
                            height: isVerySmallScreen
                                ? 12
                                : (isSmallScreen ? 16 : 20)),
                        _buildStatsGrid(isSmallScreen, isVerySmallScreen),
                        SizedBox(
                            height: isVerySmallScreen
                                ? 12
                                : (isSmallScreen ? 16 : 20)),
                        _buildActionButtons(isVerySmallScreen),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCongratulationsSection(
      Size size, bool isSmallScreen, bool isVerySmallScreen) {
    double sectionHeight;
    if (isVerySmallScreen) {
      sectionHeight = 140;
    } else if (isSmallScreen) {
      sectionHeight = 180;
    } else {
      sectionHeight = 220;
    }

    return Container(
      height: sectionHeight,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Text(
                  '🎉',
                  style: TextStyle(
                    fontSize:
                        isVerySmallScreen ? 40 : (isSmallScreen ? 50 : 65),
                  ),
                ),
              ),
              SizedBox(height: isVerySmallScreen ? 4 : 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Congrats! You Win',
                  style: TextStyle(
                    fontSize:
                        isVerySmallScreen ? 20 : (isSmallScreen ? 24 : 28),
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: isVerySmallScreen ? 2 : 4),
              Flexible(
                child: Text(
                  'Great job, $userName!',
                  style: TextStyle(
                    fontSize:
                        isVerySmallScreen ? 13 : (isSmallScreen ? 14 : 16),
                    color: const Color(0xCCFFFFFF),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle(bool isSmallScreen, bool isVerySmallScreen) {
    double circleSize;
    double fontSize;
    double labelSize;

    if (isVerySmallScreen) {
      circleSize = 120;
      fontSize = 40;
      labelSize = 12;
    } else if (isSmallScreen) {
      circleSize = 140;
      fontSize = 48;
      labelSize = 14;
    } else {
      circleSize = 170;
      fontSize = 56;
      labelSize = 15;
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Center(
        child: Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '$score',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
              SizedBox(height: isVerySmallScreen ? 2 : 4),
              Text(
                'your score',
                style: TextStyle(
                  fontSize: labelSize,
                  color: const Color(0xCCFFFFFF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(bool isSmallScreen, bool isVerySmallScreen) {
    double cardHeight;
    if (isVerySmallScreen) {
      cardHeight = 90;
    } else if (isSmallScreen) {
      cardHeight = 105;
    } else {
      cardHeight = 120;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildStatCard(
              width: cardWidth,
              height: cardHeight,
              icon: '🟡',
              value: '100%',
              label: 'Completion',
              color: const Color(0xFFffd93d),
              isSmallScreen: isSmallScreen,
              isVerySmallScreen: isVerySmallScreen,
            ),
            _buildStatCard(
              width: cardWidth,
              height: cardHeight,
              icon: '🟣',
              value: '$totalQuestions',
              label: 'Total questions',
              color: const Color(0xFF764ba2),
              isSmallScreen: isSmallScreen,
              isVerySmallScreen: isVerySmallScreen,
            ),
            _buildStatCard(
              width: cardWidth,
              height: cardHeight,
              icon: '🟢',
              value: '$correctAnswers',
              label: 'Right Answers',
              color: const Color(0xFF6bcf7f),
              isSmallScreen: isSmallScreen,
              isVerySmallScreen: isVerySmallScreen,
            ),
            _buildStatCard(
              width: cardWidth,
              height: cardHeight,
              icon: '🔴',
              value: '$wrongAnswers',
              label: 'Wrong Answers',
              color: const Color(0xFFff6b6b),
              isSmallScreen: isSmallScreen,
              isVerySmallScreen: isVerySmallScreen,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required double width,
    required double height,
    required String icon,
    required String value,
    required String label,
    required Color color,
    required bool isSmallScreen,
    required bool isVerySmallScreen,
  }) {
    double iconSize;
    double valueSize;
    double labelSize;

    if (isVerySmallScreen) {
      iconSize = 14;
      valueSize = 24;
      labelSize = 10;
    } else if (isSmallScreen) {
      iconSize = 16;
      valueSize = 28;
      labelSize = 11;
    } else {
      iconSize = 18;
      valueSize = 32;
      labelSize = 12;
    }

    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: isVerySmallScreen ? 8 : 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF3d3d5c),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: TextStyle(fontSize: iconSize),
          ),
          SizedBox(height: isVerySmallScreen ? 3 : 5),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: valueSize,
                  fontWeight: FontWeight.w800,
                  color: color,
                  height: 1,
                ),
              ),
            ),
          ),
          SizedBox(height: isVerySmallScreen ? 2 : 3),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: labelSize,
                color: const Color(0xB3FFFFFF),
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isVerySmallScreen) {
    final buttonPadding = isVerySmallScreen ? 14.0 : 16.0;
    final fontSize = isVerySmallScreen ? 15.0 : 16.0;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share feature coming soon!'),
                  backgroundColor: Color(0xFF667eea),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFffd93d),
              foregroundColor: const Color(0xFF2d2d44),
              padding: EdgeInsets.symmetric(vertical: buttonPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Share Score',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _retakeQuiz,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFffd93d),
              side: const BorderSide(
                color: Color(0xFFffd93d),
                width: 2,
              ),
              padding: EdgeInsets.symmetric(vertical: buttonPadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Take a Quiz Again',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
