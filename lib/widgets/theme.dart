import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  static const Color defaultThemeColor = Colors.blue;
  static const Color darkModeButtonColor = Color.fromARGB(255, 224, 176, 255);
  static const Color lightModeButtonColor = Colors.blue;

  ThemeData _currentTheme = ThemeData.light();

  ThemeData get currentTheme => _currentTheme;

  Color get buttonColor => _currentTheme.brightness == Brightness.dark
      ? darkModeButtonColor
      : lightModeButtonColor;

  Color get buttonTextColor => _currentTheme.brightness == Brightness.dark
      ? Colors.white
      : Colors.black;

  void setLightTheme() {
    _currentTheme = ThemeData.light().copyWith(
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightModeButtonColor,
        ),
      ),
      primaryColor: lightModeButtonColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: lightModeButtonColor,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: lightModeButtonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      
    );
    notifyListeners();
  }

  void setDarkTheme() {
    _currentTheme = ThemeData.dark().copyWith(
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkModeButtonColor,
        ),
      ),
      primaryColor: darkModeButtonColor,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: darkModeButtonColor,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: darkModeButtonColor,
        textTheme: ButtonTextTheme.primary,
      ),
    );
    notifyListeners();
  }
  void setCustomTheme(Color primaryColor) {
    Color invertColor = _invertColor(primaryColor);
    Color textColor = primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    _currentTheme = ThemeData(
      primaryColor: textColor,
      
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),
      // scaffoldBackgroundColor: textColor,
    );
    notifyListeners();
  }

  Color _invertColor(Color color) {
    return Color.fromARGB(
      255,
      255 - color.red,
      255 - color.green,
      255 - color.blue,
    );
  }
}