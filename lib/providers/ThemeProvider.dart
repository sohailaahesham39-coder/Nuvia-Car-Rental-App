import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  // Constructor loads saved theme preference
  ThemeProvider() {
    _loadSavedTheme();
  }

  // Load saved theme mode from SharedPreferences
  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('is_dark_mode');

    if (isDark != null) {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }

  // Set specific theme mode
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _saveTheme();
    notifyListeners();
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await _saveTheme();
    notifyListeners();
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDarkMode);
  }
}