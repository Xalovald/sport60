import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sport60/widgets/button.dart';
import 'package:sport60/widgets/shadow_painter.dart';
import 'shadow_painter_test.dart';

void main() {
  testWidgets('CustomButton displays child widget',
      (WidgetTester tester) async {
    // Arrange
    final onClick = () {};
    final heroTag = 'test_button';
    final child = Text('Click Me');

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onClick: onClick,
            heroTag: heroTag,
            child: child,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Click Me'), findsOneWidget);
  });

  testWidgets('CustomButton calls onClick when pressed',
      (WidgetTester tester) async {
    // Arrange
    bool clicked = false;
    final onClick = () {
      clicked = true;
    };
    final heroTag = 'test_button';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onClick: onClick,
            heroTag: heroTag,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Assert
    expect(clicked, isTrue);
  });

  testWidgets('CustomButton with noAnimation disables animations',
      (WidgetTester tester) async {
    // Arrange
    final onClick = () {};
    final heroTag = 'test_button';

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onClick: onClick,
            heroTag: heroTag,
            noAnimation: true,
          ),
        ),
      ),
    );

    final button =
        tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));

    // Assert
    expect(button.focusColor, Colors.transparent);
    expect(button.splashColor, Colors.transparent);
    expect(button.hoverColor, Colors.transparent);
    expect(button.highlightElevation, 0);
    expect(button.focusElevation, 0);
    expect(button.hoverElevation, 0);
    expect(button.disabledElevation, 0);
  });

  testWidgets('CustomButton with shadowPainter displays shadow',
      (WidgetTester tester) async {
    // Arrange
    final onClick = () {};
    final heroTag = 'test_button';
    final shadowPainter = TestShadowPainter();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            onClick: onClick,
            heroTag: heroTag,
            shadowPainter: shadowPainter,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(CustomPaint), findsOneWidget);
  });
}
