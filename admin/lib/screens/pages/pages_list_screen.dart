import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';

import 'package:fixxev_admin/core/services/api_service.dart';
import 'package:fixxev_admin/core/utils/time_utils.dart';

class PagesListScreen extends StatefulWidget {
  const PagesListScreen({super.key});

  @override
  State<PagesListScreen> createState() => _PagesListScreenState();
}

class _PagesListScreenState extends State<PagesListScreen> {
  final ApiService _apiService = ApiService();
  Map<String, String> _lastUpdatedMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPageUpdates();
  }

  Future<void> _loadPageUpdates() async {
    try {
      final pagesContent = await _apiService.getAllPagesContent();
      final updates = <String, String>{};
      for (var page in pagesContent) {
        final name = page['pageName'] as String;
        final updatedAt = page['updatedAt'];
        updates[name] = formatRelativeTime(updatedAt);
      }
      if (mounted) {
        setState(() {
          _lastUpdatedMap = updates;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    final pages = [
      {
        'name': 'Home Page',
        'slug': 'home',
        'description': 'Hero, stats, testimonials, partners',
        'icon': Icons.home_outlined,
        'route': '/pages/home',
      },
      {
        'name': 'About Page',
        'slug': 'about',
        'description': 'Company info, mission, values, CSR',
        'icon': Icons.info_outline,
        'route': '/pages/about',
      },
      {
        'name': 'Services Page',
        'slug': 'services',
        'description': 'Service offerings and details',
        'icon': Icons.build_outlined,
        'route': '/pages/services',
      },
      {
        'name': 'Products Page',
        'slug': 'products',
        'description': 'Product catalog and details',
        'icon': Icons.inventory_2_outlined,
        'route': '/pages/products',
      },
      {
        'name': 'Blog Page',
        'slug': 'blog',
        'description': 'Blog listing settings',
        'icon': Icons.article_outlined,
        'route': '/pages/blog',
      },
      {
        'name': 'Contact Page',
        'slug': 'contact',
        'description': 'Contact info, form settings',
        'icon': Icons.contact_mail_outlined,
        'route': '/pages/contact',
      },
      {
        'name': 'Franchise Page',
        'slug': 'franchise',
        'description': 'Spare Parts & Service Center Dealer',
        'icon': Icons.handshake_outlined,
        'route': '/pages/franchise',
      },
      {
        'name': 'CKD Container',
        'slug': 'ckd-container',
        'description': 'Container showroom features',
        'icon': Icons.store_outlined,
        'route': '/pages/ckd-container',
      },
      {
        'name': 'Team Page',
        'slug': 'team',
        'description': 'Manage company team members',
        'icon': Icons.people_outline,
        'route': '/pages/team',
      },
      {
        'name': 'Footer Settings',
        'slug': 'footer',
        'description': 'Global tagline, social links, contact info',
        'icon': Icons.dock_outlined,
        'route': '/pages/footer',
      },
      {
        'name': 'Navbar Settings',
        'slug': 'navbar',
        'description': 'Logo, colors, and global navigation settings',
        'icon': Icons.horizontal_split_outlined,
        'route': '/pages/navbar',
      },
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundDark,
      drawer: isMobile ? const Drawer(child: AdminSidebar(currentRoute: '/pages')) : null,
      appBar: isMobile ? AppBar(
        backgroundColor: AppColors.sidebarDark,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text('Pages', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            onPressed: _loadPageUpdates,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ) : null,
      body: Row(
        children: [
          if (!isMobile) const AdminSidebar(currentRoute: '/pages'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (Desktop only)
                  if (!isMobile)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Pages', style: AppTextStyles.heading1),
                            const SizedBox(height: 8),
                            Text(
                              'Manage content for each page of your website',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                        if (_isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          IconButton(
                            onPressed: _loadPageUpdates,
                            icon: const Icon(Icons.refresh, color: AppColors.textMuted),
                          ),
                      ],
                    ),
                  
                  if (!isMobile) const SizedBox(height: 40),

                  // Pages grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isMobile ? 1 : _calculateCrossAxisCount(screenWidth, 300),
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: isMobile ? 1.8 : 1.2,
                    ),
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      final slug = page['slug'] as String;
                      return _PageCard(
                        name: page['name'] as String,
                        description: page['description'] as String,
                        icon: page['icon'] as IconData,
                        route: page['route'] as String,
                        lastEdited: _lastUpdatedMap[slug] ?? 'Never',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateCrossAxisCount(double width, double itemWidth) {
    // Sidebar width is roughly 250px on desktop
    final availableWidth = width - 250 - 64; // Minus padding
    int count = (availableWidth / itemWidth).floor();
    return count < 1 ? 1 : count;
  }
}

class _PageCard extends StatefulWidget {
  final String name;
  final String description;
  final IconData icon;
  final String route;
  final String lastEdited;

  const _PageCard({
    required this.name,
    required this.description,
    required this.icon,
    required this.route,
    required this.lastEdited,
  });

  @override
  State<_PageCard> createState() => _PageCardState();
}

class _PageCardState extends State<_PageCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? AppColors.accentRed.withOpacity(0.5) : Colors.transparent,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.accentRed.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: AppColors.accentRed, size: 24),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isHovered ? 1 : 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.accentRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.edit, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(widget.name, style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: AppTextStyles.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Text(
                'Last edited: ${widget.lastEdited}',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
