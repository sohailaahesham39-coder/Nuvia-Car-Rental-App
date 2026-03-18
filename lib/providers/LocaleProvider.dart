import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  // Initialize with a default value
  Locale _locale = const Locale('en');
  bool _isLoaded = false;

  Locale get locale => _locale;
  bool get isLoaded => _isLoaded;

  // Constructor loads saved locale preference
  LocaleProvider() {
    _loadSavedLocale();
  }

  // Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code');

      if (languageCode != null) {
        _locale = Locale(languageCode);
      }
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
      // Fallback to default locale if there's an error
      _locale = const Locale('en');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  // Set new locale and notify listeners
  void setLocale(Locale locale) {
    if (!_isSupported(locale)) return;

    _locale = locale;
    _saveLocale(locale.languageCode);
    notifyListeners();
  }

  // Toggle between English and Arabic
  void toggleLocale() {
    final newLocale = _locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');

    setLocale(newLocale);
  }

  // Save locale preference to SharedPreferences
  Future<void> _saveLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
      // Handle potential errors when saving
    }
  }

  // Check if locale is supported
  bool _isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }
}