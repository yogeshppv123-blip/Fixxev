import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fixxev/widgets/section_header.dart';
import 'package:go_router/go_router.dart';

/// "Why Choose Us" section with hover effects and animations triggered when in view
class WhatWeDoSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const WhatWeDoSection({super.key, required this.content});

  @override
  State<WhatWeDoSection> createState() => _WhatWeDoSectionState();
}

class _WhatWeDoSectionState extends State<WhatWeDoSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasStartedAnimation = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _startAnimation() {
    if (!_hasStartedAnimation) {
      _controller.forward();
      setState(() {
        _hasStartedAnimation = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return VisibilityDetector(
      key: const Key('what_we_do_section'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.3) {
          _startAnimation();
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 80,
          vertical: 30, // Reduced spacing
        ),
        color: AppColors.white,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                // Section header with animation
                SectionHeader(
                  label: (widget.content['wwdTagline'] ?? 'FRANCHISE-LED GROWTH').toString().replaceAll('//', '').trim(),
                  title: widget.content['wwdTitle'] ?? 'BUILDING INDIA\'S LARGEST\nEV SERVICE NETWORK',
                ),
                const SizedBox(height: 60),
                // Experience cards with staggered animation
                isMobile
                    ? Column(
                        children: [
                          _AnimatedExperienceCard(
                            title: widget.content['wwdCard1Title'] ?? '500+ SERVICE CENTRES',
                            description: widget.content['wwdCard1Desc'] ?? 'A pan-India network of 500+ EV service centres across key cities and towns.',
                            icon: Icons.hub,
                            delay: 0,
                            startAnimation: _hasStartedAnimation,
                            onTap: () => context.go('/ckd-dealership'),
                          ),
                          const SizedBox(height: 24),
                          _AnimatedExperienceCard(
                            title: widget.content['wwdCard2Title'] ?? 'CERTIFIED SPARES',
                            description: widget.content['wwdCard2Desc'] ?? 'Access to OEM-certified spares and standardized service processes nationwide.',
                            icon: Icons.verified,
                            delay: 100,
                            startAnimation: _hasStartedAnimation,
                            onTap: () => context.go('/ckd-dealership'),
                          ),
                          const SizedBox(height: 24),
                          _AnimatedExperienceCard(
                            title: widget.content['wwdCard3Title'] ?? 'SKILLED TECHNICIANS',
                            description: widget.content['wwdCard3Desc'] ?? 'Expertly trained technicians supported by Fixx EV for centralized quality control.',
                            icon: Icons.engineering,
                            delay: 200,
                            startAnimation: _hasStartedAnimation,
                            onTap: () => context.go('/ckd-dealership'),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _AnimatedExperienceCard(
                                title: widget.content['wwdCard1Title'] ?? '500+ SERVICE CENTRES',
                                description: widget.content['wwdCard1Desc'] ?? 'Building a pan-India network of 500+ EV service centres across key cities and towns.',
                                icon: Icons.hub,
                                delay: 0,
                                startAnimation: _hasStartedAnimation,
                                onTap: () => context.go('/ckd-dealership'),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _AnimatedExperienceCard(
                                title: widget.content['wwdCard2Title'] ?? 'CERTIFIED & STANDARDIZED',
                                description: widget.content['wwdCard2Desc'] ?? 'OEM-certified spares and standardized service processes backed by a centralized supply chain.',
                                icon: Icons.verified,
                                delay: 150,
                                startAnimation: _hasStartedAnimation,
                                onTap: () => context.go('/ckd-dealership'),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _AnimatedExperienceCard(
                                title: widget.content['wwdCard3Title'] ?? 'EXPERT CARE',
                                description: widget.content['wwdCard3Desc'] ?? 'Skilled, trained technicians supported by Fixx EV for consistent quality and diagnostics.',
                                icon: Icons.engineering,
                                delay: 300,
                                startAnimation: _hasStartedAnimation,
                                onTap: () => context.go('/ckd-dealership'),
                              ),
                            ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



/// Experience card with hover animation
class _AnimatedExperienceCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final int delay;
  final bool startAnimation;
  final VoidCallback onTap;

  const _AnimatedExperienceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.delay,
    required this.startAnimation,
    required this.onTap,
  });

  @override
  State<_AnimatedExperienceCard> createState() => _AnimatedExperienceCardState();
}

class _AnimatedExperienceCardState extends State<_AnimatedExperienceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(_AnimatedExperienceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startAnimation && !oldWidget.startAnimation) {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -12.0 : 0.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? AppColors.accentBlue.withAlpha(40)
                        : Colors.black.withAlpha(15),
                    blurRadius: _isHovered ? 40 : 25,
                    offset: Offset(0, _isHovered ? 20 : 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image placeholder with icon overlay
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _isHovered ? AppColors.accentBlue : AppColors.primaryNavy,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: AnimatedScale(
                            scale: _isHovered ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              widget.icon,
                              size: 80,
                              color: AppColors.textLight.withAlpha(_isHovered ? 150 : 50),
                            ),
                          ),
                        ),
                        // Red accent corner
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          top: 0,
                          right: 0,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: _isHovered ? 80 : 60,
                            height: _isHovered ? 80 : 60,
                            decoration: BoxDecoration(
                              color: _isHovered ? AppColors.white : AppColors.accentBlue,
                              borderRadius: BorderRadius.only(
                                topRight: const Radius.circular(12),
                                bottomLeft: Radius.circular(_isHovered ? 80 : 60),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: AppTextStyles.cardTitle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.description,
                          style: AppTextStyles.cardDescription,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),
                        // Read more link with hover effect
                        _HoverLink(text: 'READ MORE', isHovered: _isHovered),
                      ],
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

/// Hover link component
class _HoverLink extends StatelessWidget {
  final String text;
  final bool isHovered;

  const _HoverLink({required this.text, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppTextStyles.linkText.copyWith(
            color: isHovered ? AppColors.primaryNavy : AppColors.accentBlue,
          ),
          child: Text(text),
        ),
        const SizedBox(width: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..translate(isHovered ? 6.0 : 0.0, 0.0),
          child: Icon(
            Icons.arrow_forward,
            color: isHovered ? AppColors.primaryNavy : AppColors.accentBlue,
            size: 16,
          ),
        ),
      ],
    );
  }
}
