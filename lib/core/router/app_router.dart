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

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
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
