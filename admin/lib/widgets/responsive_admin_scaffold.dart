import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';

/// Responsive wrapper for admin screens that handles sidebar/drawer on mobile
class ResponsiveAdminScaffold extends StatelessWidget {
  final String currentRoute;
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const ResponsiveAdminScaffold({
    super.key,
    required this.currentRoute,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      drawer: isMobile
          ? Drawer(
              child: AdminSidebar(currentRoute: currentRoute),
            )
          : null,
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.sidebarDark,
              title: Text(title, style: AppTextStyles.heading3),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: actions,
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) AdminSidebar(currentRoute: currentRoute),
          Expanded(
            child: body,
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
