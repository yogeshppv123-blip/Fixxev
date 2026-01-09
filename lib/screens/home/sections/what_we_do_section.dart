import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/section_header.dart';
import 'package:go_router/go_router.dart';

/// "Why Choose Us" section with robust entrance animations.
/// Removed VisibilityDetector and disabled animations for mobile to ensure proper rendering.
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
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    _controller.forward();
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

    Widget content = Column(
      children: [
        SectionHeader(
          label: (widget.content['wwdTagline'] ?? 'FRANCHISE-LED GROWTH').toString().replaceAll('//', '').trim(),
          title: widget.content['wwdTitle'] ?? 'BUILDING INDIA\'S LARGEST\nEV SERVICE NETWORK',
        ),
        const SizedBox(height: 60),
        
        isMobile
            ? Column(
                children: [
                  _ExperienceCard(
                    title: widget.content['wwdCard1Title'] ?? '500+ SERVICE CENTRES',
                    description: widget.content['wwdCard1Desc'] ?? 'A pan-India network of 500+ EV service centres across key cities and towns.',
                    icon: Icons.hub,
                    onTap: () => context.go('/ckd-dealership'),
                  ),
                  const SizedBox(height: 24),
                  _ExperienceCard(
                    title: widget.content['wwdCard2Title'] ?? 'CERTIFIED SPARES',
                    description: widget.content['wwdCard2Desc'] ?? 'Access to OEM-certified spares and standardized service processes nationwide.',
                    icon: Icons.verified,
                    onTap: () => context.go('/ckd-dealership'),
                  ),
                  const SizedBox(height: 24),
                  _ExperienceCard(
                    title: widget.content['wwdCard3Title'] ?? 'SKILLED TECHNICIANS',
                    description: widget.content['wwdCard3Desc'] ?? 'Expertly trained technicians supported by Fixx EV for centralized quality control.',
                    icon: Icons.engineering,
                    onTap: () => context.go('/ckd-dealership'),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _ExperienceCard(
                        title: widget.content['wwdCard1Title'] ?? '500+ SERVICE CENTRES',
                        description: widget.content['wwdCard1Desc'] ?? 'Building a pan-India network of 500+ EV service centres across key cities and towns.',
                        icon: Icons.hub,
                        onTap: () => context.go('/ckd-dealership'),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _ExperienceCard(
                        title: widget.content['wwdCard2Title'] ?? 'CERTIFIED & STANDARDIZED',
                        description: widget.content['wwdCard2Desc'] ?? 'OEM-certified spares and standardized service processes backed by a centralized supply chain.',
                        icon: Icons.verified,
                        onTap: () => context.go('/ckd-dealership'),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _ExperienceCard(
                        title: widget.content['wwdCard3Title'] ?? 'EXPERT CARE',
                        description: widget.content['wwdCard3Desc'] ?? 'Skilled, trained technicians supported by Fixx EV for consistent quality and diagnostics.',
                        icon: Icons.engineering,
                        onTap: () => context.go('/ckd-dealership'),
                      ),
                    ),
                ],
              ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 80,
      ),
      color: AppColors.white,
      child: isMobile 
        ? content
        : FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: content,
            ),
          ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const _ExperienceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..translate(0.0, _isHovered ? -12.0 : 0.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? AppColors.accentBlue.withAlpha(40) : Colors.black.withAlpha(15),
                blurRadius: _isHovered ? 40 : 25,
                offset: Offset(0, _isHovered ? 20 : 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _isHovered ? AppColors.accentBlue : AppColors.primaryNavy,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(
                    widget.icon,
                    size: 80,
                    color: AppColors.textLight.withAlpha(_isHovered ? 150 : 50),
                  ),
                ),
              ),
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
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'READ MORE',
                          style: TextStyle(
                            color: _isHovered ? AppColors.primaryNavy : AppColors.accentBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: _isHovered ? AppColors.primaryNavy : AppColors.accentBlue,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
