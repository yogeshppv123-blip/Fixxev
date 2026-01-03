import 'package:flutter/material.dart';
import 'package:fixxev/core/services/api_service.dart';

class ThemeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Default Fixxev Electric Blue Theme
  Color _primaryColor = const Color(0xFF437BDC);    // Electric Blue
  Color _secondaryColor = const Color(0xFF2BC155);  // Fresh Green
  Color _accentColor = const Color(0xFF4E8AFF);     // Vibrant Blue
  Color _backgroundColor = const Color(0xFFFFFFFF); // White
  Color _cardColor = const Color(0xFFF7F9FC);       // Light Grey
  
  bool _isLoading = true;

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get accentColor => _accentColor;
  Color get backgroundColor => _backgroundColor;
  Color get cardColor => _cardColor;
  bool get isLoading => _isLoading;
  
  // Gradient helpers
  LinearGradient get primaryGradient => LinearGradient(
    colors: [_primaryColor, _accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  LinearGradient get secondaryGradient => LinearGradient(
    colors: [_secondaryColor, _secondaryColor.withOpacity(0.7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    try {
      final settings = await _apiService.getSettings();
      if (settings['theme'] != null) {
        final theme = settings['theme'];
        _primaryColor = _parseColor(theme['primaryColor'], _primaryColor);
        _secondaryColor = _parseColor(theme['secondaryColor'], _secondaryColor);
        _accentColor = _parseColor(theme['accentColor'], _accentColor);
        _backgroundColor = _parseColor(theme['backgroundColor'], _backgroundColor);
        _cardColor = _parseColor(theme['cardColor'], _cardColor);
      }
    } catch (e) {
      debugPrint('Error loading theme: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> refresh() async {
    await loadTheme();
  }

  Color _parseColor(dynamic hex, Color fallback) {
    if (hex == null || hex is! String || hex.isEmpty) return fallback;
    try {
      final buffer = StringBuffer();
      if (hex.length == 6 || hex.length == 7) buffer.write('ff');
      buffer.write(hex.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return fallback;
    }
  }

  ThemeData get themeData {
    return ThemeData(
      primaryColor: _primaryColor,
      scaffoldBackgroundColor: _backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        surface: _cardColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: _cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      useMaterial3: true,
    );
  }
}

// Extension for easy access via context
extension ThemeProviderExtension on BuildContext {
  ThemeProvider get themeProvider => throw UnimplementedError('Use Provider.of or context.watch');
}

