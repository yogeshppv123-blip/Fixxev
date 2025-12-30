import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors - Matching FIXX EV Logo (Blue + Teal)
  static const Color primaryNavy = Color(0xFF0D1B2A); // Dark Navy
  static const Color accentBlue = Color(0xFF2196F3); // Blue from logo
  static const Color accentTeal = Color(0xFF00BFA5); // Teal/Green from logo
  
  // Primary accent (use for buttons, links, CTAs)
  static const Color accentRed = accentTeal; // Legacy alias - now teal
  static const Color primary = accentBlue; // Blue for primary actions
  static const Color secondary = accentTeal; // Teal for secondary/highlights
  
  // Backgrounds
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color backgroundDark = Color(0xFF1B263B);
  static const Color navDark = Color(0xFF303C49);

  // Text Colors
  static const Color textDark = Color(0xFF1B263B);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF778DA9);
  static const Color textMuted = Color(0xFF415A77);
  
  // Decorative
  static const Color shadowColor = Color(0x1F000000);
  static const Color lightMint = Color(0xFFE0F2F1); // Light teal background

  // Additional colors
  static const Color primaryDark = Color(0xFF0D1B2A);
  
  // Gradients - Blue to Teal
  static const LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF00BFA5)], // Blue to Teal
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF00BFA5)], // Blue to Teal
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF00BFA5), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

