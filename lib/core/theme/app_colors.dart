import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Brand Colors - Exactly matching images (Sky Blue + Mint Green)
  static const Color primaryNavy = Color(0xFF0D1B2A); // Dark Navy
  static const Color accentBlue = Color(0xFF4D8BFD); // Primary Blue
  static const Color accentTeal = Color(0xFF5ED3B8); // Mint Green from image
  
  // Primary brand accents
  static const Color accentRed = accentTeal; // Changed back to Green for specific accents
  static const Color primary = accentBlue;   
  static const Color secondary = accentTeal; 
  
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
  static const Color lightMint = Color(0xFFE0F2F1); 

  // Additional colors
  static const Color primaryDark = Color(0xFF0D1B2A);
  
  // Gradients - Standardized (Solid)
  static const LinearGradient redGradient = LinearGradient(
    colors: [accentBlue, accentBlue], // Primary Buttons remain Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient brandGradient = LinearGradient(
    colors: [accentBlue, accentBlue], // Brand highlights remain Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient tealGradient = LinearGradient(
    colors: [accentTeal, accentTeal], // Green accents
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [accentBlue, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

