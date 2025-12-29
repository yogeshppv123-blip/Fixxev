import 'package:flutter/material.dart';

/// FIXXEV App Color Palette
/// Dark blue theme with red accents - automotive style
class AppColors {
  AppColors._();

  // Primary Colors - Dark Navy & Red
  static const Color primaryNavy = Color(0xFF0D1B2A);
  static const Color primaryDark = Color(0xFF1B263B);
  static const Color accentRed = Color(0xFFE63946);
  static const Color accentRedLight = Color(0xFFFF6B6B);

  // Background Colors
  static const Color backgroundDark = Color(0xFF0D1B2A);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textDark = Color(0xFF1B263B);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF6C757D);
  static const Color textGrey = Color(0xFF8D99AE);

  // Accent Colors
  static const Color lightBlue = Color(0xFF4CC9F0);
  static const Color successGreen = Color(0xFF06D6A0);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient redGradient = LinearGradient(
    colors: [accentRed, Color(0xFFFF4757)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow
  static const Color shadowColor = Color(0x1A000000);
}
