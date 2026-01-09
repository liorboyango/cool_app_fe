import 'package:flutter/material.dart';

/// Centralized color definitions for Cool App
/// Following Material Design 3 principles with accessibility in mind
class AppColors {
  AppColors._();

  // ============================================
  // LIGHT THEME COLORS
  // ============================================
  
  // Primary palette
  static const Color lightPrimary = Color(0xFF2563EB);
  static const Color lightPrimaryLight = Color(0xFF3B82F6);
  static const Color lightPrimaryDark = Color(0xFF1D4ED8);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  
  // Background & Surface
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6);
  
  // Text colors
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextDisabled = Color(0xFF9CA3AF);
  static const Color lightTextOnPrimary = Color(0xFFFFFFFF);
  
  // Border & Divider
  static const Color lightBorder = Color(0xFFE5E7EB);
  static const Color lightDivider = Color(0xFFE5E7EB);
  
  // Semantic colors
  static const Color lightSuccess = Color(0xFF059669);
  static const Color lightWarning = Color(0xFFD97706);
  static const Color lightError = Color(0xFFDC2626);
  static const Color lightInfo = Color(0xFF0284C7);
  
  // ============================================
  // DARK THEME COLORS
  // ============================================
  
  // Primary palette
  static const Color darkPrimary = Color(0xFF3B82F6);
  static const Color darkPrimaryLight = Color(0xFF60A5FA);
  static const Color darkPrimaryDark = Color(0xFF2563EB);
  static const Color darkOnPrimary = Color(0xFFFFFFFF);
  
  // Background & Surface
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkSurfaceVariant = Color(0xFF374151);
  
  // Text colors
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextDisabled = Color(0xFF6B7280);
  static const Color darkTextOnPrimary = Color(0xFFFFFFFF);
  
  // Border & Divider
  static const Color darkBorder = Color(0xFF374151);
  static const Color darkDivider = Color(0xFF374151);
  
  // Semantic colors
  static const Color darkSuccess = Color(0xFF10B981);
  static const Color darkWarning = Color(0xFFF59E0B);
  static const Color darkError = Color(0xFFEF4444);
  static const Color darkInfo = Color(0xFF0EA5E9);
}