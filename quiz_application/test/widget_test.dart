// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_master/main.dart'; // Changed from quiz_application

void main() {
  testWidgets('QuizMaster app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const QuizMasterApp());

    // Verify that welcome screen is displayed
    expect(find.text('QuizMaster'), findsOneWidget);
    expect(find.text('Test your knowledge!'), findsOneWidget);

    // Verify that name input field exists
    expect(find.byType(TextFormField), findsOneWidget);

    // Verify that Start Quiz button exists
    expect(find.text('Start Quiz'), findsOneWidget);
  });

  testWidgets('Name input validation test', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const QuizMasterApp());

    // Find the start button
    final startButton = find.text('Start Quiz');

    // Try to start quiz without entering name
    await tester.tap(startButton);
    await tester.pump();

    // Verify error message appears (validation triggers)
    expect(find.text('Please enter your name'), findsOneWidget);
  });

  testWidgets('Name input accepts text', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const QuizMasterApp());

    // Find the text field
    final textField = find.byType(TextFormField);

    // Enter text
    await tester.enterText(textField, 'Test User');
    await tester.pump();

    // Verify text was entered
    expect(find.text('Test User'), findsOneWidget);
  });

  testWidgets('Navigation to quiz screen test', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const QuizMasterApp());

    // Find the text field and enter valid name
    final textField = find.byType(TextFormField);
    await tester.enterText(textField, 'Test User');
    await tester.pump();

    // Tap start button
    final startButton = find.text('Start Quiz');
    await tester.tap(startButton);
    await tester.pumpAndSettle(); // Wait for navigation animation

    // Verify we're on quiz screen by checking for timer or question
    expect(find.textContaining('Question'), findsWidgets);
  });

  testWidgets('Feature cards are displayed', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(const QuizMasterApp());

    // Verify feature cards text
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('Score'), findsOneWidget);
    expect(find.text('Subjects'), findsOneWidget);
  });
}
