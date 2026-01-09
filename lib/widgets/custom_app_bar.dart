import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/core/constants/app_constants.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';
import 'package:fixxev/core/services/api_service.dart';
import 'package:fixxev/core/providers/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

/// Custom App Bar with dynamic content from Admin
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  Size get preferredSize => const Size.fromHeight(80); // Standard navbar height

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic> _navbarData = {};
  Map<String, dynamic> _settingsData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      final results = await Future.wait([
        _apiService.getPageContent('navbar'),
        _apiService.getSettings(),
      ]);
      if (mounted) {
        setState(() {
          _navbarData = results[0];
          _settingsData = results[1];
        });
      }
    } catch (e) {
      debugPrint('Error loading navbar data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  Color _getBackgroundColor() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    if (widget.isTransparent) return Colors.transparent;
    
    final hexStr = _navbarData['bgColor'] as String?;
    // Default to PURE WHITE if data is missing or invalid
    return AppColors.fromHex(hexStr, AppColors.white);
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final bgColor = _getBackgroundColor();
    final isDarkBg = bgColor.computeLuminance() < 0.5;
    // Only use light text if explicitly requested OR if the background is actually dark
    // NOT automatically when transparent, as hero sections can be light.
    final bool lightText = widget.useLightText || (isDarkBg && !widget.isTransparent);

    return Column(
      children: [
        // Top Bar removed per user request
        // if (!isMobile) _buildTopBar(lightText),
        
        Container(
          height: 80,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 60,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            boxShadow: (widget.isTransparent || widget.backgroundColor != null || isDarkBg)
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
                child: _buildLogo(lightText),
              ),
              // Navigation or Menu
              if (isMobile)
                IconButton(
                  onPressed: widget.onMenuPressed,
                  icon: Icon(
                    Icons.menu,
                    color: lightText ? AppColors.textLight : AppColors.textDark,
                    size: 28,
                  ),
                )
              else
                _isLoading ? const SizedBox(width: 200) : _buildNavigationLinks(context, lightText),
              // CTA Button
              if (!isMobile)
                PrimaryButton(
                  text: _navbarData['ctaText'] ?? 'GET A QUOTE',
                  icon: Icons.arrow_forward,
                  onPressed: () => context.go('/contact'),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(bool lightText) {
    final email = _settingsData['contactEmail'] ?? AppConstants.email;
    final phone = _settingsData['contactPhone'] ?? AppConstants.phoneNumber;

    return Container(
      width: double.infinity,
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: lightText ? Colors.white.withAlpha(20) : AppColors.primaryNavy,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildTopBarItem(
            icon: Icons.alternate_email,
            label: email,
            onTap: () => _launchUrl('mailto:$email'),
          ),
          const SizedBox(width: 24),
          _buildTopBarItem(
            icon: Icons.phone_in_talk,
            label: phone,
            onTap: () => _launchUrl('tel:$phone'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBarItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(bool isLight) {
    final logoUrl = _navbarData['logoUrl'] as String?;
    final double? width = double.tryParse(_navbarData['logoWidth']?.toString() ?? '140');
    final double? height = double.tryParse(_navbarData['logoHeight']?.toString() ?? '50');

    return Container(
      height: height ?? 55,
      padding: const EdgeInsets.symmetric(vertical: 4),
      constraints: BoxConstraints(maxWidth: width ?? 180),
      child: Image.network(
        (logoUrl != null && logoUrl.isNotEmpty) ? logoUrl : 'logo.png',
        fit: BoxFit.contain,
        // Apply color filter ONLY if we are using the default 'logo.png' and on a white background
        color: (!isLight && (logoUrl == null || logoUrl.isEmpty)) ? AppColors.primaryNavy : null,
        colorBlendMode: (!isLight && (logoUrl == null || logoUrl.isEmpty)) ? BlendMode.srcIn : null,
        errorBuilder: (context, error, stackTrace) => _buildDefaultLogo(isLight),
      ),
    );
  }

  Widget _buildDefaultLogo(bool isLight) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.accentBlue,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text(
              'F',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'FIXX',
                style: (isLight ? AppTextStyles.navLinkLight : AppTextStyles.navLink).copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: isLight ? AppColors.textLight : AppColors.fromHex(_navbarData['textColor'], AppColors.primaryNavy),
                ),
              ),
              TextSpan(
                text: 'EV',
                style: (isLight ? AppTextStyles.navLinkLight : AppTextStyles.navLink).copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: AppColors.accentTeal,
                ),
              ),
            ],
          ),
        ),
      ],
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

    // Force Blue if the data is missing or accidentally set to black in Admin
    Color textColor = AppColors.fromHex(_navbarData['textColor'], AppColors.primaryNavy);
    
    // Intelligently override if the color is too dark (near black)
    // 0xFF001F3F is dark navy, 0xFF000000 is black.
    if (!isLight && textColor.computeLuminance() < 0.15) {
      textColor = AppColors.primaryNavy; 
    }

    final hoverColor = AppColors.fromHex(_navbarData['hoverColor'], AppColors.accentTeal);
    final activeColor = AppColors.fromHex(_navbarData['activeColor'], AppColors.accentTeal);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: navItems.map((item) {
        final isActive = currentPath == item['path'];
        return _NavItem(
          label: item['label']!,
          isLight: isLight,
          isActive: isActive,
          textColor: textColor,
          hoverColor: hoverColor,
          activeColor: activeColor,
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
  final Color textColor;
  final Color hoverColor;
  final Color activeColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isLight,
    required this.isActive,
    required this.textColor,
    required this.hoverColor,
    required this.activeColor,
    required this.onTap,
  });

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
                style: (widget.isLight ? AppTextStyles.navLinkLight : AppTextStyles.navLink).copyWith(
                  fontSize: 13,
                  fontWeight: (_isHovered || widget.isActive) ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isActive 
                      ? widget.activeColor 
                      : (_isHovered ? widget.hoverColor : (widget.isLight ? AppColors.textLight : widget.textColor)),
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
                  color: widget.isActive ? widget.activeColor : widget.hoverColor,
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

class MobileDrawer extends StatefulWidget {
  const MobileDrawer({super.key});

  @override
  State<MobileDrawer> createState() => _MobileDrawerState();
}

class _MobileDrawerState extends State<MobileDrawer> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic> _navbarData = {};
  Map<String, dynamic> _settingsData = {};

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final results = await Future.wait([
      _apiService.getPageContent('navbar'),
      _apiService.getSettings(),
    ]);
    if (mounted) {
      setState(() {
        _navbarData = results[0];
        _settingsData = results[1];
      });
    }
  }

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

    final logoUrl = _navbarData['logoUrl'] as String?;
    final email = _settingsData['contactEmail'] ?? AppConstants.email;
    final phone = _settingsData['contactPhone'] ?? AppConstants.phoneNumber;

    final bgColor = AppColors.fromHex(_navbarData['bgColor'], AppColors.white);
    Color textColor = AppColors.fromHex(_navbarData['textColor'], AppColors.primaryNavy);
    if (textColor.computeLuminance() < 0.15) {
      textColor = AppColors.primaryNavy;
    }

    return Drawer(
      child: Container(
        color: bgColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Image.network(
                    (logoUrl != null && logoUrl.isNotEmpty) ? logoUrl : 'logo.png',
                    height: double.tryParse(_navbarData['logoHeight']?.toString() ?? '50'),
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                    errorBuilder: (context, error, stackTrace) => Text(
                      'FIXXEV',
                      style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: AppColors.textLight.withAlpha(30),
              ),
              // Contact info removed per user request
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: navItems.map((item) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                      title: Text(
                        item['label']!.toUpperCase(),
                        style: AppTextStyles.navLink.copyWith(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: textColor,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: textColor,
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
              Padding(
                padding: const EdgeInsets.all(24),
                child: PrimaryButton(
                  text: _navbarData['ctaText'] ?? 'GET A QUOTE',
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

  Widget _buildDrawerContactItem(IconData icon, String label, String url) {
    return InkWell(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) await launchUrl(uri);
      },
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 14),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}
