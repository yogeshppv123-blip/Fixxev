import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/section_header.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';
import 'package:go_router/go_router.dart';

/// About Us section with interactive statistics and Mission 500 info.
/// Disabled animations for mobile to ensure robust rendering.
class AboutUsSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const AboutUsSection({super.key, required this.content});

  @override
  State<AboutUsSection> createState() => _AboutUsSectionState();
}

class _AboutUsSectionState extends State<AboutUsSection> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideLeftAnimation;
  late Animation<Offset> _slideRightAnimation;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _slideLeftAnimation = Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic)),
    );

    _slideRightAnimation = Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _mainController, curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic)),
    );

    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      color: Colors.white,
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Side: Image and Stats
        Expanded(
          flex: 5,
          child: SlideTransition(
            position: _slideLeftAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  _AnimatedImageSection(imageUrl: widget.content['aboutImage']),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 80),
        // Right Side: Content
        Expanded(
          flex: 6,
          child: SlideTransition(
            position: _slideRightAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildContentSection(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Image at top for mobile
        _AnimatedImageSection(imageUrl: widget.content['aboutImage']),
        const SizedBox(height: 40),
        _buildContentSection(),
      ],
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          label: (widget.content['aboutTagline'] ?? 'ANNOUNCING MISSION 500').toString().replaceAll('//', '').trim(),
          title: widget.content['aboutTitle'] ?? "SOLVING INDIA’S EV\nAFTER-SALES GAP",
          isLight: false,
          centered: false,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: 32),
        _buildRichText(
          widget.content['aboutDesc1'] ?? '**Fixx EV Technologies Pvt. Ltd.** is on a mission to solve one of the biggest barriers to electric vehicle adoption in India — **reliable after-sales service and spares availability**.'
        ),
        const SizedBox(height: 24),
        _buildRichText(
          widget.content['aboutDesc2'] ?? 'We are building a nationwide, standardized EV after-sales network by appointing **500 Fixx EV Authorized Franchise Service Centres** across key cities and towns in India.'
        ),
        const SizedBox(height: 12),
        if (widget.content['aboutDesc3'] != null)
          _buildRichText(widget.content['aboutDesc3']!),
        const SizedBox(height: 48),
        PrimaryButton(
          text: 'READ MORE',
          onPressed: () => context.go('/about'),
          icon: Icons.arrow_forward,
        ),
      ],
    );
  }

  Widget _buildRichText(String text) {
    List<TextSpan> spans = [];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 1) {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
        ));
      } else {
        spans.add(TextSpan(text: parts[i]));
      }
    }
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6, fontSize: 16),
        children: spans,
      ),
    );
  }
}

class _AnimatedImageSection extends StatelessWidget {
  final String? imageUrl;
  const _AnimatedImageSection({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Container(
      height: isMobile ? 300 : 420,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        image: DecorationImage(
          image: (imageUrl != null && imageUrl!.isNotEmpty)
              ? NetworkImage(imageUrl!)
              : const AssetImage('assets/images/about_hero.png') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
