import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors - Matching FIXX EV Logo (Blue + Teal)
  static const Color primaryNavy = Color(0xFF0D1B2A);
  static const Color accentBlue = Color(0xFF2196F3); // Blue from logo
  static const Color accentTeal = Color(0xFF00BFA5); // Teal from logo
  static const Color navDark = Color(0xFF303C49);
  
  // Primary accent (use for buttons, links, CTAs)
  static const Color accentRed = accentTeal; // Legacy alias - now teal
  static const Color primary = accentBlue;
  static const Color secondary = accentTeal;
  
  // Backgrounds
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1B263B);
  static const Color sidebarDark = Color(0xFF1A1D21);
  static const Color cardDark = Color(0xFF252A30);
  
  // Text Colors
  static const Color textDark = Color(0xFF1B263B);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF778DA9);
  static const Color textMuted = Color(0xFF9CA3AF);
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
}
