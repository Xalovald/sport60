import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const Color defaultLightButtonColor = Colors.blue;
  static const Color defaultDarkButtonColor = Color.fromARGB(255, 224, 176, 255);

  ThemeData _currentTheme = ThemeData.light();
  Color _customButtonColor = defaultLightButtonColor;

  ThemeNotifier() {
    _loadThemePreference();
  }

  ThemeData get currentTheme => _currentTheme;

  void setLightTheme() async {
    _customButtonColor = defaultLightButtonColor;
    _currentTheme = ThemeData.light().copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _customButtonColor,
          foregroundColor: Colors.white,
        ),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.white,
        secondary: defaultLightButtonColor,
        inversePrimary: _getContrastingTextColor(defaultLightButtonColor),
      ),
    );
    notifyListeners();
    await _saveThemePreference('light');
  }

  void setDarkTheme() async {
    _customButtonColor = defaultDarkButtonColor;
    _currentTheme = ThemeData.dark().copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _customButtonColor,
          foregroundColor: Colors.black,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
        ),
      ),
      primaryColor: Colors.black,
      colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.black,
        secondary: defaultDarkButtonColor,
        inversePrimary: _getContrastingTextColor(defaultDarkButtonColor),
      ),
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