import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fixxev/widgets/section_header.dart';
import 'package:go_router/go_router.dart';

/// Services section with grid layout and hover animations triggered when in view
class ServicesSection extends StatefulWidget {
  const ServicesSection({super.key});

  @override
  State<ServicesSection> createState() => _ServicesSectionState();
}

class _ServicesSectionState extends State<ServicesSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
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

    final services = [
      {
        'icon': Icons.settings_suggest,
        'title': 'AIOT Diagnostics',
        'description': 'Real-time system profiling with advanced AIOT-integrated diagnostic protocols.',
      },
      {
        'icon': Icons.battery_charging_full,
        'title': 'BMS Optimization',
        'description': 'Precise cell balancing, thermal profiling and state-of-charge calibration.',
      },
      {
        'icon': Icons.electrical_services,
        'title': 'Hardware Calibration',
        'description': 'Calibration of high-voltage components and power electronics controllers.',
      },
      {
        'icon': Icons.speed,
        'title': 'Torque Management',
        'description': 'Drive-unit optimization and precision motor-control firmware tuning.',
      },
      {
        'icon': Icons.car_repair,
        'title': 'Chassis Dynamics',
        'description': 'Precision suspension tuning and structural integrity analysis for premium EVs.',
      },
      {
        'icon': Icons.support_agent,
        'title': 'Fleet Assistance',
        'description': '24/7 technical field support and remote diagnostic assistance via cloud.',
      },
    ];

    return VisibilityDetector(
      key: const Key('services_section'),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.3) {
          _startAnimation();
        }
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 80,
            vertical: 100,
          ),
          color: AppColors.backgroundLight,
          child: Column(
            children: [
              const SectionHeader(
                label: '// OUR SERVICES',
                title: 'ADVANCED MULTI-BRAND\nEV SOLUTIONS',
              ),
              const SizedBox(height: 60),
              // Services grid with staggered animations
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : (screenWidth < 1024 ? 2 : 3),
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: isMobile ? 2.2 : 1.5,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return _AnimatedServiceCard(
                    icon: service['icon'] as IconData,
                    title: service['title'] as String,
                    description: service['description'] as String,
                    delay: index * 100,
                    startAnimation: _hasStartedAnimation,
                    onTap: () => context.go('/services'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Service card with hover animation
class _AnimatedServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delay;
  final bool startAnimation;
  final VoidCallback onTap;

  const _AnimatedServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
    required this.startAnimation,
    required this.onTap,
  });

  @override
  State<_AnimatedServiceCard> createState() => _AnimatedServiceCardState();
}

class _AnimatedServiceCardState extends State<_AnimatedServiceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
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
  void didUpdateWidget(_AnimatedServiceCard oldWidget) {
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
                ..translate(0.0, _isHovered ? -10.0 : 0.0),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: _isHovered 
                    ? AppColors.primaryNavy 
                    : AppColors.primaryNavy.withAlpha(15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isHovered 
                      ? AppColors.accentRed 
                      : AppColors.primaryNavy.withAlpha(30),
                  width: _isHovered ? 2 : 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? AppColors.accentRed.withAlpha(40)
                        : Colors.black.withAlpha(10),
                    blurRadius: _isHovered ? 40 : 20,
                    offset: Offset(0, _isHovered ? 20 : 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon with animated background
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: AppColors.accentRed,
                          borderRadius: BorderRadius.circular(15),
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
                        child: AnimatedScale(
                          scale: _isHovered ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(widget.icon, color: AppColors.white, size: 32),
                        ),
                      ),
                      // Counter or decorative element
                      Text(
                        '0${widget.delay ~/ 100 + 1}',
                        style: AppTextStyles.heroTitle.copyWith(
                          fontSize: 40,
                          color: _isHovered 
                              ? AppColors.white.withAlpha(20) 
                              : AppColors.primaryNavy.withAlpha(15),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: AppTextStyles.cardTitle.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _isHovered ? AppColors.textLight : AppColors.primaryNavy,
                    ),
                    child: Text(widget.title),
                  ),
                  const SizedBox(height: 12),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: AppTextStyles.cardDescription.copyWith(
                      fontSize: 15,
                      height: 1.5,
                      color: _isHovered 
                          ? AppColors.textLight.withAlpha(200) 
                          : AppColors.textDark.withAlpha(180),
                    ),
                    child: Text(
                      widget.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  // Arrow button with hover effect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: _isHovered ? AppColors.white : AppColors.primaryNavy,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _isHovered
                              ? [
                                  BoxShadow(
                                    color: AppColors.white.withAlpha(50),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: _isHovered ? AppColors.accentRed : AppColors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
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
