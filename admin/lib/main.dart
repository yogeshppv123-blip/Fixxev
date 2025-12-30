import 'package:flutter/material.dart';
import 'package:fixxev_admin/screens/login/login_screen.dart';
import 'package:fixxev_admin/screens/dashboard/dashboard_screen.dart';
import 'package:fixxev_admin/screens/pages/pages_list_screen.dart';
import 'package:fixxev_admin/screens/leads/leads_screen.dart';
import 'package:fixxev_admin/screens/blog/blog_list_screen.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';

void main() {
  runApp(const FixxevAdminApp());
}

class FixxevAdminApp extends StatelessWidget {
  const FixxevAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIXXEV Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        primaryColor: AppColors.accentRed,
        colorScheme: ColorScheme.dark(
          primary: AppColors.accentRed,
          secondary: AppColors.accentRed,
          background: AppColors.backgroundDark,
          surface: AppColors.cardDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.sidebarDark,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.sidebarDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/pages': (context) => const PagesListScreen(),
        '/leads': (context) => const LeadsScreen(),
        '/blog': (context) => const BlogListScreen(),
        // Placeholder routes - to be implemented
        '/products': (context) => _placeholderScreen('Products'),
        '/media': (context) => _placeholderScreen('Media'),
        '/settings': (context) => _placeholderScreen('Settings'),
        '/pages/home': (context) => _placeholderScreen('Edit Home Page'),
        '/pages/about': (context) => _placeholderScreen('Edit About Page'),
        '/pages/products': (context) => _placeholderScreen('Edit Products Page'),
        '/pages/blog': (context) => _placeholderScreen('Edit Blog Page'),
        '/pages/contact': (context) => _placeholderScreen('Edit Contact Page'),
        '/pages/dealership': (context) => _placeholderScreen('Edit Dealership Page'),
        '/blog/new': (context) => _placeholderScreen('New Blog Post'),
        '/products/new': (context) => _placeholderScreen('New Product'),
      },
    );
  }

  Widget _placeholderScreen(String title) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.sidebarDark,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
