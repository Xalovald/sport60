import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sport60/domain/session_domain.dart';
import 'package:sport60/domain/exercise_domain.dart';
import 'package:sport60/domain/session_exercise_domain.dart';
import 'package:sport60/domain/session_type_domain.dart';
import 'package:sport60/services/session_service.dart';
import 'package:sport60/services/session_type_service.dart';
import 'package:sport60/services/session_exercise_service.dart';
import 'package:sport60/services/exercise_service.dart';
import 'package:sport60/views/session/create.dart';

void main() {
  testWidgets('CreateSession widget test', (WidgetTester tester) async {
    // Build the CreateSession widget
    await tester.pumpWidget(MaterialApp(
      home: CreateSession(),
    ));

    // Verify that the initial UI is correct
    expect(find.text('Create Session'), findsOneWidget);
    expect(find.text('Session Name'), findsOneWidget);
    expect(find.text('Session Type'), findsOneWidget);
    expect(find.text('Total duration (s)'), findsOneWidget);
    expect(find.text('Sélectionner un exercice'), findsOneWidget);
    expect(find.text('Duration (s)'), findsOneWidget);
    expect(find.text('Repetitions'), findsOneWidget);
    expect(find.text('Series'), findsOneWidget);
    expect(find.text('Pause entre exercice'), findsOneWidget);
    expect(find.text('pause entre série'), findsOneWidget);
    expect(find.text('Add Exercise to Session'), findsOneWidget);
    expect(find.text('Create Session'), findsOneWidget);

    // Enter session name
    await tester.enterText(find.byType(TextFormField).first, 'Test Session');

    // Select session type
    await tester.tap(find.byType(DropdownButtonFormField<int>).first);
    await tester.pumpAndSettle();
    await tester
        .tap(find.text('Type 1').last); // Adjust based on your session types
    await tester.pumpAndSettle();

    // Enter total duration
    await tester.enterText(find.byType(TextFormField).at(1), '120');

    // Select an exercise
    await tester.tap(find.byType(DropdownButtonFormField<int>).last);
    await tester.pumpAndSettle();
    await tester
        .tap(find.text('Exercise 1').last); // Adjust based on your exercises
    await tester.pumpAndSettle();

    // Enter exercise duration
    await tester.enterText(find.byType(TextFormField).at(2), '30');

    // Enter exercise repetitions
    await tester.enterText(find.byType(TextFormField).at(3), '10');

    // Enter exercise series
    await tester.enterText(find.byType(TextFormField).at(4), '3');

    // Enter exercise pause time
    await tester.enterText(find.byType(TextFormField).at(5), '10');

    // Enter exercise serie pause time
    await tester.enterText(find.byType(TextFormField).at(6), '5');

    // Add exercise to session
    await tester.tap(find.text('Add Exercise to Session'));
    await tester.pumpAndSettle();

    // Verify that the exercise is added to the session
    expect(find.text('Exercises in Session:'), findsOneWidget);
    expect(find.text('Exercise 1'), findsOneWidget);
    expect(
        find.text(
            'Duration: 30s, Reps: 10, Series: 3, Pause Exercise: 10s, Pause série: 5s'),
        findsOneWidget);

    // Create the session
    await tester.tap(find.text('Create Session'));
    await tester.pumpAndSettle();

    // Verify that the session is created successfully
    expect(find.text('Session created successfully!'), findsOneWidget);
  });
}
