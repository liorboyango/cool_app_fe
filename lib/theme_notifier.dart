import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeNotifier() {
    _loadThemeMode();
  }
  
  ThemeMode get themeMode => _themeMode;
  
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemeMode();
    notifyListeners();
  }
  
  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      // Default to light when toggling from system
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    }
    _saveThemeMode();
    notifyListeners();
  }
  
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('theme_mode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }
  
  Future<void> _saveThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', _themeMode.index);
  }
}