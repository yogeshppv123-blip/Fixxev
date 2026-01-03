import 'package:flutter/material.dart';
import 'package:fixxev_admin/screens/login/login_screen.dart';
import 'package:fixxev_admin/screens/dashboard/dashboard_screen.dart';
import 'package:fixxev_admin/screens/pages/pages_list_screen.dart';
import 'package:fixxev_admin/screens/leads/leads_screen.dart';
import 'package:fixxev_admin/screens/blog/blog_list_screen.dart';
import 'package:fixxev_admin/screens/products/products_screen.dart';
import 'package:fixxev_admin/screens/media/media_screen.dart';
import 'package:fixxev_admin/screens/settings/settings_screen.dart';
import 'package:fixxev_admin/screens/settings/theme_settings_screen.dart';
import 'package:fixxev_admin/screens/services/services_list_screen.dart';
import 'package:fixxev_admin/screens/team/team_list_screen.dart';
import 'package:fixxev_admin/screens/blog/blog_edit_screen.dart';
import 'package:fixxev_admin/screens/products/product_edit_screen.dart';
import 'package:fixxev_admin/screens/services/service_edit_screen.dart';
import 'package:fixxev_admin/screens/team/member_edit_screen.dart';
import 'package:fixxev_admin/screens/pages/home_page_editor.dart';
import 'package:fixxev_admin/screens/pages/about_page_editor.dart';
import 'package:fixxev_admin/screens/pages/contact_page_editor.dart';
import 'package:fixxev_admin/screens/pages/franchise_page_editor.dart';
import 'package:fixxev_admin/screens/pages/blog_page_editor.dart';
import 'package:fixxev_admin/screens/pages/products_page_editor.dart';
import 'package:fixxev_admin/screens/pages/ckd_container_page_editor.dart';
import 'package:fixxev_admin/screens/pages/services_page_editor.dart';
import 'package:fixxev_admin/screens/pages/team_page_editor.dart';
import 'package:fixxev_admin/screens/pages/footer_editor.dart';
import 'package:fixxev_admin/screens/pages/navbar_editor.dart';
import 'package:fixxev_admin/screens/about/about_list_screen.dart';
import 'package:fixxev_admin/screens/about/about_edit_screen.dart';
import 'package:fixxev_admin/screens/franchise/franchise_list_screen.dart';
import 'package:fixxev_admin/screens/franchise/franchise_edit_screen.dart';
import 'package:fixxev_admin/screens/ckd/ckd_list_screen.dart';
import 'package:fixxev_admin/screens/ckd/ckd_edit_screen.dart';
import 'package:fixxev_admin/screens/profile/profile_screen.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';

import 'package:fixxev_admin/core/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
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
        '/profile': (context) => const ProfileScreen(),
        '/pages': (context) => const PagesListScreen(),
        '/leads': (context) => const LeadsScreen(),
        '/blog': (context) => const BlogListScreen(),
        '/products': (context) => const ProductsScreen(),
        '/media': (context) => const MediaScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/theme-settings': (context) => const ThemeSettingsScreen(),
        // New Sections
        '/services': (context) => const ServicesListScreen(),
        '/team': (context) => const TeamListScreen(),
        // Pages Editing Placeholders
        // Pages Editing
        '/pages/home': (context) => const HomePageEditor(),
        '/pages/about': (context) => const AboutPageEditor(),
        '/pages/products': (context) => const ProductsPageEditor(),
        '/pages/blog': (context) => const BlogPageEditor(),
        '/pages/contact': (context) => const ContactPageEditor(),
        '/pages/dealership': (context) => const FranchisePageEditor(),
        '/pages/franchise': (context) => const FranchisePageEditor(), // Reuses dealership editor for franchise
        '/pages/services': (context) => const ServicesPageEditor(),
        '/pages/ckd-container': (context) => const CKDContainerPageEditor(),
        '/pages/team': (context) => const TeamPageEditor(),
        '/pages/footer': (context) => const FooterEditor(),
        '/pages/navbar': (context) => const NavbarEditor(),
        '/blog/new': (context) => const BlogEditScreen(),
        '/blog/edit': (context) {
          final blog = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return BlogEditScreen(blog: blog);
        },
        '/products/new': (context) => const ProductEditScreen(),
        '/products/edit': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return ProductEditScreen(product: product);
        },
        '/services/new': (context) => const ServiceEditScreen(),
        '/services/edit': (context) {
          final service = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return ServiceEditScreen(service: service);
        },
        '/team/new': (context) => const MemberEditScreen(),
        '/team/edit': (context) {
          final member = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return MemberEditScreen(member: member);
        },
        // Franchise Types
        '/franchise': (context) => const FranchiseListScreen(),
        '/franchise/new': (context) => const FranchiseEditScreen(),
        '/franchise/edit': (context) {
          final franchiseType = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return FranchiseEditScreen(franchiseType: franchiseType);
        },
        // CKD Features
        '/ckd-content': (context) => const CKDListScreen(),
        '/ckd-content/new': (context) => const CKDEditScreen(),
        '/ckd-content/edit': (context) {
          final feature = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return CKDEditScreen(feature: feature);
        },
      },
    );
  }

  Widget _placeholderScreen(String title, {String activeRoute = ''}) {
    // If no specific route provided, try to guess from title or default to empty
    final route = activeRoute.isNotEmpty ? activeRoute : '/${title.toLowerCase().replaceAll(' ', '-')}';
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          // Sidebar
          AdminSidebar(currentRoute: route),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                // AppBar-like header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundDark,
                    border: Border(bottom: BorderSide(color: AppColors.sidebarDark)),
                  ),
                  child: Row(
                    children: [
                      Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.construction, size: 64, color: AppColors.textMuted),
                        const SizedBox(height: 16),
                        Text(
                          '$title Page',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textLight),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Coming soon...',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

