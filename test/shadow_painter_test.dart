import 'package:flutter/material.dart';
import 'package:sport60/widgets/shadow_painter.dart';

class TestShadowPainter extends ShadowPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Implémentation de la méthode paint pour les besoins du test
    // Vous pouvez laisser cette méthode vide ou ajouter une implémentation de base
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
