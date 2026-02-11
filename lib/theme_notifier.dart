import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;
  bool _isInitialized = false;

  ThemeMode get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;

  ThemeNotifier() {
    _loadThemeFromPreferences();
  }

  /// Load the saved theme mode from shared preferences
  Future<void> _loadThemeFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      }
    } catch (e) {
      // If loading fails, keep the default light theme
      debugPrint('Error loading theme preference: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Toggle theme and save to shared preferences
  Future<void> toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, isOn ? 'dark' : 'light');
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }
}