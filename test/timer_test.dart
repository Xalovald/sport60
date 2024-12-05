import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sport60/widgets/sound.dart';
import 'package:sport60/widgets/timer.dart';

void main() {
  testWidgets('CountdownTimer displays initial time',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountdownTimer(
            maxTime: 10,
            onTimeUp: () {},
            autoStart: false,
          ),
        ),
      ),
    );

    expect(find.text('Temps restant: 10 secondes'), findsOneWidget);
  });

  testWidgets(
      'CountdownTimer starts counting down when start button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountdownTimer(
            maxTime: 10,
            onTimeUp: () {},
            autoStart: false,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Démarrer'));
    await tester.pump();

    expect(find.text('Temps restant: 9 secondes'), findsOneWidget);
  });

  testWidgets('CountdownTimer auto starts when autoStart is true',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountdownTimer(
            maxTime: 10,
            onTimeUp: () {},
            autoStart: true,
          ),
        ),
      ),
    );

    await tester.pump(Duration(seconds: 1));

    expect(find.text('Temps restant: 9 secondes'), findsOneWidget);
  });

  testWidgets('CountdownTimer calls onTimeUp when time is up',
      (WidgetTester tester) async {
    bool timeUpCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountdownTimer(
            maxTime: 1,
            onTimeUp: () {
              timeUpCalled = true;
            },
            autoStart: true,
          ),
        ),
      ),
    );

    await tester.pump(Duration(seconds: 2));

    expect(timeUpCalled, isTrue);
    expect(find.text('Temps écoulé!'), findsOneWidget);
  });

  testWidgets('CountdownTimer plays sound when time is up',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CountdownTimer(
            maxTime: 1,
            onTimeUp: () {},
            autoStart: true,
          ),
        ),
      ),
    );

    await tester.pump(Duration(seconds: 2));

    expect(find.byType(SoundWidget), findsOneWidget);
  });
}
