import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/core/constants/app_constants.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';
import 'package:go_router/go_router.dart';

/// Custom App Bar with dark navy theme
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isTransparent;
  final Color? backgroundColor;
  final bool useLightText;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onContactPressed;

  const CustomAppBar({
    super.key,
    this.isTransparent = false,
    this.backgroundColor,
    this.useLightText = false,
    this.onMenuPressed,
    this.onContactPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? (isTransparent
            ? Colors.transparent
            : AppColors.white),
        boxShadow: (isTransparent || backgroundColor != null)
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          InkWell(
             onTap: () => context.go('/'),
            child: _buildLogo(isTransparent || useLightText),
          ),
          // Navigation or Menu
          if (isMobile)
            IconButton(
              onPressed: onMenuPressed,
              icon: Icon(
                Icons.menu,
                color: (isTransparent || useLightText) ? AppColors.textLight : AppColors.textDark,
                size: 28,
              ),
            )
          else
            _buildNavigationLinks(context, isTransparent || useLightText),
          // CTA Button (desktop only)
          if (!isMobile)
            PrimaryButton(
              text: 'GET A QUOTE',
              icon: Icons.arrow_forward,
              onPressed: () => context.go('/contact'),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isLight) {
    return Container(
      height: 55, // Increased size
      padding: const EdgeInsets.symmetric(vertical: 4),
      constraints: const BoxConstraints(maxWidth: 180),
      child: Image.network(
        'logo.png', 
        fit: BoxFit.contain,
        // If !isLight (i.e. we are on a white background), we color the logo Navy to make it visible
        // This assumes the source logo has transparency and white text/graphics.
        color: !isLight ? AppColors.primaryNavy : null,
        colorBlendMode: !isLight ? BlendMode.srcIn : null,
        errorBuilder: (context, error, stackTrace) {
           return Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppColors.accentRed,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(child: Text('F', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
              const SizedBox(width: 10),
              Text('FIXXEV', style: (isLight ? AppTextStyles.navLinkLight : AppTextStyles.navLink).copyWith(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavigationLinks(BuildContext context, bool isLight) {
    final GoRouterState state = GoRouterState.of(context);
    final String currentPath = state.uri.toString();

    final navItems = [
      {'label': 'HOME', 'path': '/'},
      {'label': 'ABOUT', 'path': '/about'},
      {'label': 'SERVICES', 'path': '/services'},
      {'label': 'PRODUCTS', 'path': '/products'},
      {'label': 'CKD-CONTAINER', 'path': '/ckd-container'},
      {'label': 'FRANCHISE', 'path': '/ckd-dealership'},
      {'label': 'BLOG', 'path': '/blog'},
      {'label': 'CONTACT', 'path': '/contact'},
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: navItems.map((item) {
        final isActive = currentPath == item['path'];
        return _NavItem(
          label: item['label']!, 
          isLight: isLight,
          isActive: isActive,
          onTap: () => context.go(item['path']!),
        );
      }).toList(),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool isLight;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.isLight, required this.isActive, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: (widget.isLight
                        ? AppTextStyles.navLinkLight
                        : AppTextStyles.navLink)
                    .copyWith(
                  fontSize: 13,
                  fontWeight: (_isHovered || widget.isActive) ? FontWeight.w700 : FontWeight.w500,
                  color: (_isHovered || widget.isActive)
                      ? AppColors.accentRed 
                      : (widget.isLight ? AppColors.textLight : AppColors.textDark),
                  letterSpacing: 0.5,
                ),
                child: Text(widget.label),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 2,
                width: (_isHovered || widget.isActive) ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppColors.accentRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mobile navigation drawer
class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'label': 'HOME', 'path': '/'},
      {'label': 'ABOUT', 'path': '/about'},
      {'label': 'SERVICES', 'path': '/services'},
      {'label': 'PRODUCTS', 'path': '/products'},
      {'label': 'CKD-CONTAINER', 'path': '/ckd-container'},
      {'label': 'FRANCHISE', 'path': '/ckd-dealership'},
      {'label': 'BLOG', 'path': '/blog'},
      {'label': 'CONTACT', 'path': '/contact'},
    ];

    return Drawer(
      child: Container(
        color: AppColors.primaryNavy,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      constraints: const BoxConstraints(maxWidth: 160),
                      child: Image.network(
                        'logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppColors.textLight.withAlpha(30),
              ),
              // Navigation links
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: navItems.map((item) {
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        item['label']!.toUpperCase(),
                        style: AppTextStyles.navLinkLight.copyWith(
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.textGrey,
                        size: 14,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        context.go(item['path']!);
                      },
                    );
                  }).toList(),
                ),
              ),
              // Contact button
              Padding(
                padding: const EdgeInsets.all(24),
                child: PrimaryButton(
                  text: 'GET A QUOTE',
                  icon: Icons.arrow_forward,
                  width: double.infinity,
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/contact');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
