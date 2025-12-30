import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/core/constants/app_constants.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';
import 'package:go_router/go_router.dart';

/// Footer widget with hover effects and animations
class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

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
              vertical: 60,
            ),
            child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ),
          // Bottom bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            decoration: const BoxDecoration(
              color: AppColors.backgroundDark,
            ),
            child: Center(
              child: Text(
                '© ${DateTime.now().year} FIXXEV. All Rights Reserved.',
                style: AppTextStyles.footerText.copyWith(fontSize: 13),
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
        // Company Info
        Expanded(
          flex: 4,
          child: _buildCompanyInfo(),
        ),
        const SizedBox(width: 60),
        // Quick Links
        Expanded(
          flex: 2,
          child: _FooterLinksColumn(
            title: 'EXPLORE',
            links: const [
              {'label': 'About FIXXEV', 'path': '/about'},
              {'label': 'Our Services', 'path': '/services'},
              {'label': 'Dealership', 'path': '/ckd-dealership'},
              {'label': 'Team Experts', 'path': '/team'},
              {'label': 'Get in Touch', 'path': '/contact'},
            ],
          ),
        ),
        const SizedBox(width: 60),
        // Giant Icons Contact Area (Matching Reference Image)
        Expanded(
          flex: 5,
          child: _buildGiantContactIcons(),
        ),
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
            {'label': 'Services', 'path': '/services'},
            {'label': 'Dealership', 'path': '/ckd-dealership'},
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
        // Animated Logo
        const _AnimatedLogo(),
        const SizedBox(height: 32),
        Text(
          '**Fixx EV Technologies Pvt. Ltd.** is building India’s largest, nationwide standardized EV after-sales service and spares network. Solving the biggest barriers to EV adoption.',
          style: AppTextStyles.footerText.copyWith(height: 1.8),
        ),
        const SizedBox(height: 32),
        _buildSocialLinks(),
      ],
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      children: [
        _AnimatedSocialButton(icon: Icons.facebook),
        const SizedBox(width: 12),
        _AnimatedSocialButton(icon: Icons.camera_alt_outlined),
        const SizedBox(width: 12),
        _AnimatedSocialButton(icon: Icons.link),
        const SizedBox(width: 12),
        _AnimatedSocialButton(icon: Icons.play_arrow),
      ],
    );
  }

  Widget _buildGiantContactIcons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _GiantIconRow(icon: Icons.phone_in_talk, text: AppConstants.phoneNumber),
        const SizedBox(height: 32),
        _GiantIconRow(icon: Icons.alternate_email, text: AppConstants.email),
        _GiantIconRow(icon: Icons.location_on_outlined, text: AppConstants.address),
      ],
    );
  }
}

class _GiantIconRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _GiantIconRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          text,
          style: AppTextStyles.footerText.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accentRed.withAlpha(40),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentRed.withAlpha(100), width: 1),
          ),
          child: Icon(icon, color: AppColors.accentRed, size: 48),
        ),
      ],
    );
  }
}

/// Animated logo with hover effect
class _AnimatedLogo extends StatefulWidget {
  const _AnimatedLogo();

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
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 48,
            height: 48,
            transform: Matrix4.identity()
              ..rotateZ(_isHovered ? 0.1 : 0.0),
            decoration: BoxDecoration(
              color: AppColors.accentRed,
              borderRadius: BorderRadius.circular(10),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.accentRed.withAlpha(80),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [],
            ),
            child: const Center(
              child: Text(
                'F',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: AppTextStyles.sectionTitleLight.copyWith(
              fontSize: 26,
              color: _isHovered ? AppColors.accentRed : AppColors.textLight,
            ),
            child: const Text('FIXXEV'),
          ),
        ],
      ),
    );
  }
}

/// Animated social button
class _AnimatedSocialButton extends StatefulWidget {
  final IconData icon;

  const _AnimatedSocialButton({required this.icon});

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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: 44,
        height: 44,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.accentRed : AppColors.textLight.withAlpha(15),
          borderRadius: BorderRadius.circular(8),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accentRed.withAlpha(50),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            widget.icon,
            color: AppColors.textLight,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// Footer links column with hover effects
class _FooterLinksColumn extends StatelessWidget {
  final String title;
  final List<Map<String, String>> links;

  const _FooterLinksColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.sectionTitleLight.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: 3,
          color: AppColors.accentRed,
        ),
        const SizedBox(height: 20),
        ...links.map((link) => _AnimatedFooterLink(
          text: link['label']!,
          onTap: () => context.go(link['path']!),
        )),
      ],
    );
  }
}

/// Animated footer link
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
                transform: Matrix4.identity()
                  ..translate(_isHovered ? 4.0 : 0.0, 0.0),
                child: Icon(
                  Icons.chevron_right,
                  color: _isHovered ? AppColors.textLight : AppColors.accentRed,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: AppTextStyles.footerLink.copyWith(
                  color: _isHovered ? AppColors.accentRed : AppColors.textLight,
                ),
                child: Text(widget.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Animated contact row
class _AnimatedContactRow extends StatefulWidget {
  final IconData icon;
  final String text;

  const _AnimatedContactRow({required this.icon, required this.text});

  @override
  State<_AnimatedContactRow> createState() => _AnimatedContactRowState();
}

class _AnimatedContactRowState extends State<_AnimatedContactRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 40,
            height: 40,
            transform: Matrix4.identity()
              ..scale(_isHovered ? 1.1 : 1.0),
            decoration: BoxDecoration(
              color: _isHovered 
                  ? AppColors.accentRed 
                  : AppColors.accentRed.withAlpha(30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon, 
              color: _isHovered ? AppColors.white : AppColors.accentRed, 
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: AppTextStyles.footerText.copyWith(
                  height: 1.5,
                  color: _isHovered ? AppColors.textLight : AppColors.textGrey,
                ),
                child: Text(widget.text),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
