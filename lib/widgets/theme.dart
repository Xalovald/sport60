import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const Color defaultLightButtonColor = Colors.blueAccent;
  static const Color defaultDarkButtonColor = Color.fromARGB(255, 232, 102, 255);

  ThemeData _currentTheme = ThemeData.light();
  Color _customButtonColor = defaultLightButtonColor;

  ThemeNotifier() {
    _loadThemePreference();
  }

  ThemeData get currentTheme => _currentTheme;
  Color get customButtonColor => _customButtonColor;

  void setLightTheme() async {
    _customButtonColor = defaultLightButtonColor;
    _currentTheme = ThemeData.light().copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: const IconThemeData(color: Colors.black),
      scaffoldBackgroundColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultLightButtonColor,
          foregroundColor: Colors.black,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: defaultLightButtonColor, // button text color
        ),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        primary: defaultLightButtonColor, // header background color
        onPrimary: Colors.black, // header text color
        onSurface: defaultLightButtonColor, // body text color
        secondary: defaultLightButtonColor,
        inversePrimary: _getContrastingTextColor(defaultLightButtonColor),
        tertiary: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: defaultLightButtonColor,
        selectionColor: defaultDarkButtonColor,
        selectionHandleColor: defaultLightButtonColor,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
    );
    notifyListeners();
    await _saveThemePreference('light');
  }

  void setDarkTheme() async {
    _customButtonColor = defaultDarkButtonColor;
    _currentTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.black,
      primaryIconTheme: const IconThemeData(color: Colors.white),
      scaffoldBackgroundColor: Colors.black,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultDarkButtonColor,
          foregroundColor: Colors.white,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: defaultDarkButtonColor, // button text color
        ),
      ),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: defaultDarkButtonColor,
        onPrimary: Colors.white,
        onSurface: defaultDarkButtonColor,
        secondary: defaultDarkButtonColor,
        inversePrimary: _getContrastingTextColor(defaultDarkButtonColor),
        tertiary: Colors.black,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: defaultDarkButtonColor,
        selectionColor: defaultLightButtonColor,
        selectionHandleColor: defaultDarkButtonColor,
      ),
      textTheme: ThemeData.dark().textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      brightness: Brightness.dark,
    );
    notifyListeners();
    await _saveThemePreference('dark');
  }

  Future<void> _saveThemePreference(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'light';
    if (theme == 'light') {
      setLightTheme();
    } else {
      setDarkTheme();
    }
  }

  Color _getContrastingTextColor(Color color) {
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}