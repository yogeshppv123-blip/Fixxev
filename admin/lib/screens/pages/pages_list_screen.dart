import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/widgets/sidebar.dart';

class PagesListScreen extends StatelessWidget {
  const PagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      {
        'name': 'Home Page',
        'description': 'Hero, stats, testimonials, partners',
        'icon': Icons.home_outlined,
        'route': '/pages/home',
        'lastEdited': '2 days ago',
      },
      {
        'name': 'About Page',
        'description': 'Company info, mission, values, CSR',
        'icon': Icons.info_outline,
        'route': '/pages/about',
        'lastEdited': '1 week ago',
      },
      {
        'name': 'Services Page',
        'description': 'Service offerings and details',
        'icon': Icons.build_outlined,
        'route': '/pages/services',
        'lastEdited': 'Updated',
      },
      {
        'name': 'Products Page',
        'description': 'Product catalog and details',
        'icon': Icons.inventory_2_outlined,
        'route': '/pages/products',
        'lastEdited': '3 days ago',
      },
      {
        'name': 'Blog Page',
        'description': 'Blog listing settings',
        'icon': Icons.article_outlined,
        'route': '/pages/blog',
        'lastEdited': '5 days ago',
      },
      {
        'name': 'Contact Page',
        'description': 'Contact info, form settings',
        'icon': Icons.contact_mail_outlined,
        'route': '/pages/contact',
        'lastEdited': '1 week ago',
      },
      {
        'name': 'Franchise Page',
        'description': 'Spare Parts & Service Center Dealer',
        'icon': Icons.handshake_outlined,
        'route': '/pages/franchise',
        'lastEdited': 'Updated',
      },
      {
        'name': 'CKD Container',
        'description': 'Container showroom features',
        'icon': Icons.store_outlined,
        'route': '/pages/ckd-container',
        'lastEdited': '2 days ago',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          const AdminSidebar(currentRoute: '/pages'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text('Pages', style: AppTextStyles.heading1),
                  const SizedBox(height: 8),
                  Text(
                    'Manage content for each page of your website',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 40),

                  // Pages grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return _PageCard(
                        name: page['name'] as String,
                        description: page['description'] as String,
                        icon: page['icon'] as IconData,
                        route: page['route'] as String,
                        lastEdited: page['lastEdited'] as String,
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
