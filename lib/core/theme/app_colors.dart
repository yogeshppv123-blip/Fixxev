import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primaryNavy = Color(0xFF0D1B2A); // Dark Navy from reference
  static const Color accentRed = Color(0xFFE53935);    // Standard FIXXEV Red
  
  // Backgrounds
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1B263B);
  
  // Text Colors
  static const Color textDark = Color(0xFF1B263B);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF778DA9);
  static const Color textMuted = Color(0xFF415A77);
  
  // Decorative
  static const Color shadowColor = Color(0x1F000000);
  static const Color lightMint = Color(0xFFF1F8E9); // For form backgrounds

  // Missing colors
  static const Color primaryDark = Color(0xFF0D1B2A);
  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFD32F2F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
