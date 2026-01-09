import 'package:flutter/material.dart';

class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // ============== LIGHT THEME COLORS ==============
  static const Color _lightPrimary = Color(0xFF2563EB);
  static const Color _lightPrimaryVariant = Color(0xFF1D4ED8);
  static const Color _lightSecondary = Color(0xFF64748B);
  static const Color _lightBackground = Color(0xFFF8FAFC);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightError = Color(0xFFDC2626);
  static const Color _lightOnPrimary = Color(0xFFFFFFFF);
  static const Color _lightOnBackground = Color(0xFF1E293B);
  static const Color _lightOnSurface = Color(0xFF334155);
  static const Color _lightOnSurfaceVariant = Color(0xFF64748B);

  // ============== DARK THEME COLORS ==============
  static const Color _darkPrimary = Color(0xFF60A5FA);
  static const Color _darkPrimaryVariant = Color(0xFF3B82F6);
  static const Color _darkSecondary = Color(0xFF94A3B8);
  static const Color _darkBackground = Color(0xFF0F172A);
  static const Color _darkSurface = Color(0xFF1E293B);
  static const Color _darkError = Color(0xFFF87171);
  static const Color _darkOnPrimary = Color(0xFF0F172A);
  static const Color _darkOnBackground = Color(0xFFF1F5F9);
  static const Color _darkOnSurface = Color(0xFFE2E8F0);
  static const Color _darkOnSurfaceVariant = Color(0xFF94A3B8);

  // ============== LIGHT THEME ==============
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: _lightPrimary,
      primaryContainer: _lightPrimaryVariant,
      secondary: _lightSecondary,
      secondaryContainer: Color(0xFFE2E8F0),
      background: _lightBackground,
      surface: _lightSurface,
      error: _lightError,
      onPrimary: _lightOnPrimary,
      onSecondary: Color(0xFFFFFFFF),
      onBackground: _lightOnBackground,
      onSurface: _lightOnSurface,
      onError: Color(0xFFFFFFFF),
      outline: Color(0xFFCBD5E1),
      surfaceVariant: Color(0xFFF1F5F9),
    ),
    scaffoldBackgroundColor: _lightBackground,
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: _lightSurface,
      foregroundColor: _lightOnBackground,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: _lightOnBackground,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      elevation: 0,
      color: _lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _lightPrimary,
        foregroundColor: _lightOnPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _lightPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _lightPrimary,
        side: const BorderSide(color: _lightPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _lightPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _lightError),
      ),
      hintStyle: const TextStyle(color: _lightOnSurfaceVariant),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _lightSurface,
      selectedItemColor: _lightPrimary,
      unselectedItemColor: _lightOnSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Navigation Bar Theme (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _lightSurface,
      indicatorColor: _lightPrimary.withOpacity(0.1),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: _lightPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: _lightOnSurfaceVariant,
          fontSize: 12,
        );
      }),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _lightPrimary,
      foregroundColor: _lightOnPrimary,
      elevation: 2,
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 1,
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: _lightOnBackground, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: _lightOnBackground, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: _lightOnBackground, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: _lightOnBackground, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: _lightOnBackground, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: _lightOnBackground, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: _lightOnBackground, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: _lightOnBackground, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: _lightOnSurface, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: _lightOnSurface),
      bodyMedium: TextStyle(color: _lightOnSurface),
      bodySmall: TextStyle(color: _lightOnSurfaceVariant),
      labelLarge: TextStyle(color: _lightOnSurface, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: _lightOnSurfaceVariant),
      labelSmall: TextStyle(color: _lightOnSurfaceVariant),
    ),
  );

  // ============== DARK THEME ==============
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimary,
      primaryContainer: _darkPrimaryVariant,
      secondary: _darkSecondary,
      secondaryContainer: Color(0xFF334155),
      background: _darkBackground,
      surface: _darkSurface,
      error: _darkError,
      onPrimary: _darkOnPrimary,
      onSecondary: Color(0xFF0F172A),
      onBackground: _darkOnBackground,
      onSurface: _darkOnSurface,
      onError: Color(0xFF0F172A),
      outline: Color(0xFF475569),
      surfaceVariant: Color(0xFF334155),
    ),
    scaffoldBackgroundColor: _darkBackground,
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: _darkSurface,
      foregroundColor: _darkOnBackground,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: _darkOnBackground,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      elevation: 0,
      color: _darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155), width: 1),
      ),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _darkPrimary,
        foregroundColor: _darkOnPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _darkPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _darkPrimary,
        side: const BorderSide(color: _darkPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF475569)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF475569)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _darkError),
      ),
      hintStyle: const TextStyle(color: _darkOnSurfaceVariant),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkSurface,
      selectedItemColor: _darkPrimary,
      unselectedItemColor: _darkOnSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    
    // Navigation Bar Theme (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkSurface,
      indicatorColor: _darkPrimary.withOpacity(0.1),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            color: _darkPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }
        return const TextStyle(
          color: _darkOnSurfaceVariant,
          fontSize: 12,
        );
      }),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _darkPrimary,
      foregroundColor: _darkOnPrimary,
      elevation: 2,
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: Color(0xFF334155),
      thickness: 1,
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: _darkOnBackground, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: _darkOnBackground, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: _darkOnBackground, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: _darkOnBackground, fontWeight: FontWeight.w600),
      headlineMedium: TextStyle(color: _darkOnBackground, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: _darkOnBackground, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: _darkOnBackground, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: _darkOnBackground, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: _darkOnSurface, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: _darkOnSurface),
      bodyMedium: TextStyle(color: _darkOnSurface),
      bodySmall: TextStyle(color: _darkOnSurfaceVariant),
      labelLarge: TextStyle(color: _darkOnSurface, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: _darkOnSurfaceVariant),
      labelSmall: TextStyle(color: _darkOnSurfaceVariant),
    ),
  );
}
