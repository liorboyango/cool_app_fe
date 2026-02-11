import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
// Conditionally import dart:html for web
import 'dart:html' as html show window;

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeNotifier() {
    // Load theme from localStorage on web platform
    if (kIsWeb) {
      _loadThemeFromStorage();
    }
  }

  ThemeMode get themeMode => _themeMode;

  /// Load theme mode from localStorage (web only)
  void _loadThemeFromStorage() {
    try {
      final storedTheme = html.window.localStorage['themeMode'];
      if (storedTheme != null) {
        _themeMode = storedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (e) {
      // If localStorage is not available, default to light theme
      _themeMode = ThemeMode.light;
    }
  }

  /// Save theme mode to localStorage (web only)
  void _saveThemeToStorage() {
    if (kIsWeb) {
      try {
        final themeString = _themeMode == ThemeMode.dark ? 'dark' : 'light';
        html.window.localStorage['themeMode'] = themeString;
      } catch (e) {
        // Silently fail if localStorage is not available
      }
    }
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    _saveThemeToStorage();
    notifyListeners();
  }
}
