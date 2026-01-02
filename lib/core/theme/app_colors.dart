import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Branding Colors (Electric Blue & White Style)
  static const Color electricBlue = Color(0xFF437BDC); // #437bdc - Main Blue
  static const Color vibrantBlue = Color(0xFF4E8AFF);  // #4e8aff - Lighter Blue
  static const Color cleanWhite = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF7F9FC);
  static const Color darkText = Color(0xFF1A1A1A);
  
  // Legacy Aliases (mapped to new theme)
  static const Color primaryNavy = electricBlue; // Map old Navy to Blue
  static const Color accentBlue = vibrantBlue;   // Use lighter blue here
  static const Color accentTeal = Color(0xFF2BC155); // Fresh Green Accent
  static const Color accentRed = electricBlue;   // Map old RED to BLUE to remove red!
  
  // Primary brand accents
  static const Color primary = electricBlue;   
  static const Color secondary = accentTeal; 
  
  // Backgrounds
  static const Color white = cleanWhite;
  static const Color backgroundLight = lightGrey;
  static const Color backgroundDark = cleanWhite; // Remove dark backgrounds, make them white
  static const Color navDark = electricBlue;      // Navbar becomes Blue
  static const Color cardDark = cleanWhite;       // Cards become white

  // Text Colors
  static const Color textDark = darkText;
  static const Color textLight = cleanWhite;
  static const Color textGrey = Color(0xFF777777);
  static const Color textMuted = Color(0xFF999999);
  
  // Decorative
  static const Color shadowColor = Color(0x1A000000); // Lighter shadow
  static const Color lightMint = Color(0xFFE3F2FD);   // Light Blue (was mint)

  // Additional colors
  static const Color primaryDark = electricBlue;
  
  // Gradients - Updated to Blue
  static const LinearGradient redGradient = LinearGradient(
    colors: [electricBlue, vibrantBlue], 
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient brandGradient = LinearGradient(
    colors: [electricBlue, vibrantBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient tealGradient = LinearGradient(
    colors: [accentTeal, Color(0xFF25A04A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [electricBlue, vibrantBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

