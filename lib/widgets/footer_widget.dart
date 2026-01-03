import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/core/constants/app_constants.dart';
import 'package:fixxev/core/services/api_service.dart';
import 'package:fixxev/core/providers/theme_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

/// Footer widget with hover effects and animations
class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic> _footerData = {};
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
        _apiService.getPageContent('footer'),
        _apiService.getSettings(),
      ]);
      if (mounted) {
        setState(() {
          _footerData = results[0];
          _settingsData = results[1];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 80,
              vertical: 30,
            ),
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),
          // Bottom bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            decoration: const BoxDecoration(
              color: AppColors.backgroundDark,
            ),
            child: Center(
              child: Text(
                '© ${DateTime.now().year} FIXXEV. All Rights Reserved.',
                style: AppTextStyles.footerText.copyWith(fontSize: 12, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _buildCompanyInfo()),
        const SizedBox(width: 60),
        Expanded(
          flex: 2,
          child: _FooterLinksColumn(
            title: 'EXPLORE',
            links: const [
              {'label': 'About FIXXEV', 'path': '/about'},
              {'label': 'Products', 'path': '/products'},
              {'label': 'Dealership', 'path': '/ckd-dealership'},
              {'label': 'Blog', 'path': '/blog'},
              {'label': 'Team Experts', 'path': '/team'},
              {'label': 'Get in Touch', 'path': '/contact'},
            ],
          ),
        ),
        const SizedBox(width: 60),
        Expanded(flex: 5, child: _buildGiantContactIcons()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanyInfo(),
        const SizedBox(height: 60),
        _FooterLinksColumn(
          title: 'QUICK LINKS',
          links: const [
            {'label': 'Home', 'path': '/'},
            {'label': 'About Us', 'path': '/about'},
            {'label': 'Products', 'path': '/products'},
            {'label': 'Dealership', 'path': '/ckd-dealership'},
            {'label': 'Blog', 'path': '/blog'},
            {'label': 'Team', 'path': '/team'},
            {'label': 'Contact', 'path': '/contact'},
          ],
        ),
        const SizedBox(height: 60),
        _buildGiantContactIcons(),
      ],
    );
  }

  Widget _buildCompanyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AnimatedLogo(logoUrl: _footerData['logo']),
        const SizedBox(height: 16),
        Text(
          _footerData['tagline'] ?? 'Fixx EV Technologies Pvt. Ltd. is building India’s largest, nationwide standardized EV after-sales service and spares network.',
          style: AppTextStyles.footerText.copyWith(height: 1.5, color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 16),
        _buildSocialLinks(),
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      children: [
        if (_footerData['facebook']?.isNotEmpty == true)
          _AnimatedSocialButton(icon: FontAwesomeIcons.facebookF, onTap: () => _launchUrl(_footerData['facebook'])),
        if (_footerData['instagram']?.isNotEmpty == true || _footerData['instagram'] == null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: _AnimatedSocialButton(icon: FontAwesomeIcons.instagram, onTap: () => _launchUrl(_footerData['instagram'] ?? AppConstants.instagramUrl)),
          ),
        if (_footerData['linkedin']?.isNotEmpty == true || _footerData['linkedin'] == null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: _AnimatedSocialButton(icon: FontAwesomeIcons.linkedinIn, onTap: () => _launchUrl(_footerData['linkedin'] ?? AppConstants.linkedinUrl)),
          ),
        if (_footerData['whatsapp']?.isNotEmpty == true || _footerData['whatsapp'] == null)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: _AnimatedSocialButton(icon: FontAwesomeIcons.whatsapp, onTap: () => _launchUrl(_footerData['whatsapp'] ?? AppConstants.whatsappUrl)),
          ),
        if (_footerData['youtube']?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: _AnimatedSocialButton(icon: FontAwesomeIcons.youtube, onTap: () => _launchUrl(_footerData['youtube'])),
          ),
      ],
    );
  }

  Widget _buildGiantContactIcons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GiantIconRow(
          icon: Icons.phone_in_talk, 
          text: _footerData['phone'] ?? AppConstants.phoneNumber,
          onTap: () => _launchUrl('tel:${_footerData['phone'] ?? AppConstants.phoneNumber}'),
        ),
        const SizedBox(height: 12),
        _GiantIconRow(
          icon: Icons.alternate_email, 
          text: _footerData['email'] ?? AppConstants.email,
          onTap: () => _launchUrl('mailto:${_footerData['email'] ?? AppConstants.email}'),
        ),
        const SizedBox(height: 12),
        _GiantIconRow(
          icon: Icons.location_on_outlined, 
          text: _footerData['address'] ?? AppConstants.address,
        ),
      ],
    );
  }
}

class _GiantIconRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  const _GiantIconRow({required this.icon, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.white.withAlpha(100), width: 1),
                ),
                child: Icon(icon, color: AppColors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  text,
                  style: AppTextStyles.footerText.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  final String? logoUrl;
  const _AnimatedLogo({this.logoUrl});
  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: widget.logoUrl != null && widget.logoUrl!.isNotEmpty
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 60,
              transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
              child: Image.network(
                widget.logoUrl!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => _buildDefaultLogo(),
              ),
            )
          : _buildDefaultLogo(),
    );
  }

  Widget _buildDefaultLogo() {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 48,
          height: 48,
          transform: Matrix4.identity()..rotateZ(_isHovered ? 0.1 : 0.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: _isHovered ? [const BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 8))] : [],
          ),
          child: const Center(
            child: Text(
              'F',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.electricBlue),
            ),
          ),
        ),
        const SizedBox(width: 12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'FIXX',
                style: AppTextStyles.sectionTitleLight.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: _isHovered ? AppColors.accentTeal : AppColors.textLight,
                ),
              ),
              TextSpan(
                text: 'EV',
                style: AppTextStyles.sectionTitleLight.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accentTeal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnimatedSocialButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AnimatedSocialButton({required this.icon, required this.onTap});
  @override
  State<_AnimatedSocialButton> createState() => _AnimatedSocialButtonState();
}

class _AnimatedSocialButtonState extends State<_AnimatedSocialButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: 44,
          height: 44,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -4.0 : 0.0),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.white : AppColors.textLight.withAlpha(15),
            borderRadius: BorderRadius.circular(8),
            boxShadow: _isHovered ? [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 15, offset: const Offset(0, 6))] : [],
          ),
          child: AnimatedScale(
            scale: _isHovered ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: Icon(
              widget.icon,
              color: _isHovered ? AppColors.electricBlue : AppColors.textLight,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLinksColumn extends StatelessWidget {
  final String title;
  final List<Map<String, String>> links;
  const _FooterLinksColumn({required this.title, required this.links});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionTitleLight.copyWith(fontSize: 16)),
        const SizedBox(height: 4),
        Container(width: 30, height: 3, color: AppColors.accentTeal),
        const SizedBox(height: 20),
        ...links.map((link) => _AnimatedFooterLink(text: link['label']!, onTap: () => context.go(link['path']!))),
      ],
    );
  }
}

class _AnimatedFooterLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const _AnimatedFooterLink({required this.text, required this.onTap});
  @override
  State<_AnimatedFooterLink> createState() => _AnimatedFooterLinkState();
}

class _AnimatedFooterLinkState extends State<_AnimatedFooterLink> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()..translate(_isHovered ? 4.0 : 0.0, 0.0),
                child: Icon(Icons.chevron_right, color: _isHovered ? AppColors.white : AppColors.secondary, size: 16),
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.footerLink.copyWith(color: _isHovered ? AppColors.secondary : AppColors.textLight),
                child: Text(widget.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
