import 'package:flutter/material.dart';
import 'package:fixxev_admin/core/theme/app_colors.dart';
import 'package:fixxev_admin/core/theme/app_text_styles.dart';
import 'package:fixxev_admin/core/services/api_service.dart';

class AdminSidebar extends StatefulWidget {
  final String currentRoute;

  const AdminSidebar({super.key, required this.currentRoute});

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  final ApiService _apiService = ApiService();
  String _leadsCount = '...';
  String? _logoUrl;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _loadLeadsCount();
    _loadNavbarData();
  }

  Future<void> _loadLeadsCount() async {
    try {
      final leads = await _apiService.getLeads();
      if (mounted) {
        setState(() {
          _leadsCount = leads.length.toString();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _leadsCount = '0';
        });
      }
    }
  }

  Future<void> _loadNavbarData() async {
    try {
      final navbarData = await _apiService.getPageContent('navbar');
      if (mounted && navbarData['logoUrl'] != null) {
        setState(() {
          _logoUrl = navbarData['logoUrl'];
        });
      }
    } catch (e) {
      // Fallback to defaults
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = widget.currentRoute;
    return Container(
      width: 260,
      color: AppColors.sidebarDark,
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            alignment: Alignment.centerLeft,
            child: _logoUrl != null
                ? Image.network(
                    _logoUrl!,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => _buildLogoFallback(),
                  )
                : Image.network(
                    'logo.png',
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => _buildLogoFallback(),
                  ),
          ),


          const Divider(color: AppColors.cardDark, height: 1),

          // Navigation
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              children: [
                _SidebarSection(
                  title: 'MAIN',
                  items: [
                    _SidebarItem(
                      icon: Icons.dashboard_outlined,
                      activeIcon: Icons.dashboard,
                      label: 'Dashboard',
                      route: '/dashboard',
                      isActive: currentRoute == '/dashboard',
                    ),
                    _SidebarItem(
                      icon: Icons.mail_outline,
                      activeIcon: Icons.mail,
                      label: 'Leads & Inquiries',
                      route: '/leads',
                      isActive: currentRoute == '/leads',
                      badge: _leadsCount,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SidebarSection(
                  title: 'CONTENT',
                  items: [
                    _SidebarItem(
                      icon: Icons.web_outlined,
                      activeIcon: Icons.web,
                      label: 'Pages',
                      route: '/pages',
                      isActive: currentRoute.startsWith('/pages'),
                    ),
                    _SidebarItem(
                      icon: Icons.photo_library_outlined,
                      activeIcon: Icons.photo_library,
                      label: 'Media',
                      route: '/media',
                      isActive: currentRoute == '/media',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _SidebarSection(
                  title: 'SETTINGS',
                  items: [
                    _SidebarItem(
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: 'My Profile',
                      route: '/profile',
                      isActive: currentRoute == '/profile',
                    ),
                    _SidebarItem(
                      icon: Icons.settings_outlined,
                      activeIcon: Icons.settings,
                      label: 'General Settings',
                      route: '/settings',
                      isActive: currentRoute == '/settings',
                    ),
                    _SidebarItem(
                      icon: Icons.palette_outlined,
                      activeIcon: Icons.palette,
                      label: 'Theme Settings',
                      route: '/theme-settings',
                      isActive: currentRoute == '/theme-settings',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Logout
          Container(
            padding: const EdgeInsets.all(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.logout, color: AppColors.textMuted, size: 20),
                      const SizedBox(width: 12),
                      Text('Sign Out', style: AppTextStyles.sidebarItem),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoFallback() {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: AppColors.accentTeal, borderRadius: BorderRadius.circular(8)),
          child: const Center(child: Text('F', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24))),
        ),
        const SizedBox(width: 12),
        const Text('FIXXEV', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)),
      ],
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String title;
  final List<_SidebarItem> items;

  const _SidebarSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 12),
          child: Text(
            title,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textGrey,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final bool isActive;
  final String? badge;

  const _SidebarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    required this.isActive,
    this.badge,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, widget.route);
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: widget.isActive
                    ? AppColors.accentRed.withOpacity(0.15)
                    : (_isHovered ? AppColors.cardDark : Colors.transparent),
                borderRadius: BorderRadius.circular(10),
                border: widget.isActive
                    ? Border.all(color: AppColors.accentRed.withOpacity(0.3))
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isActive ? widget.activeIcon : widget.icon,
                    color: widget.isActive ? AppColors.accentRed : AppColors.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: widget.isActive
                          ? AppTextStyles.sidebarItemActive.copyWith(color: AppColors.accentRed)
                          : AppTextStyles.sidebarItem,
                    ),
                  ),
                  if (widget.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
