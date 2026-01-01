import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/about/about_screen.dart';
import '../../screens/services/services_page.dart';
import '../../screens/team/team_screen.dart';
import '../../screens/contact/contact_screen.dart';
import '../../screens/business/ckd_dealership_screen.dart';
import '../../screens/business/ckd_container_screen.dart';
import '../../screens/products/products_screen.dart';
import '../../screens/blog/blog_screen.dart';

import '../../screens/maintenance/maintenance_screen.dart';
import '../../core/services/api_service.dart';

class AppRouter {
  static final _apiService = ApiService();

  static final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      try {
        final settings = await _apiService.getSettings();
        final isMaintenance = settings['maintenanceMode'] ?? false;
        
        if (isMaintenance && state.uri.path != '/maintenance') {
          return '/maintenance';
        }
        if (!isMaintenance && state.uri.path == '/maintenance') {
          return '/';
        }
      } catch (e) {
        // If API fails, assume not maintenance
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/maintenance',
        builder: (context, state) => const MaintenanceScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/services',
        builder: (context, state) => const ServicesPage(),
      ),
      GoRoute(
        path: '/team',
        builder: (context, state) => const TeamScreen(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: '/ckd-dealership',
        builder: (context, state) => const CKDealershipScreen(),
      ),
      GoRoute(
        path: '/ckd-container',
        builder: (context, state) => const CKDContainerScreen(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: '/blog',
        builder: (context, state) => const BlogScreen(),
      ),
    ],
  );
}
