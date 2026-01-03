import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fixxev/widgets/section_header.dart';
import 'package:go_router/go_router.dart';

/// Services section with grid layout and hover animations triggered when in view
class ServicesSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const ServicesSection({super.key, required this.content});

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

    final dynamic dynamicServices = widget.content['serviceCards'];
    final List<Map<String, dynamic>> services = (dynamicServices != null && dynamicServices is List && dynamicServices.isNotEmpty)
        ? dynamicServices.asMap().entries.map((e) {
            final card = e.value;
            // Map icons based on index to keep visuals consistent
            final icons = [Icons.memory, Icons.electrical_services, Icons.battery_charging_full, Icons.sensors,Icons.tire_repair, Icons.handyman];
            return {
              'icon': icons[e.key % icons.length],
              'title': (card['title'] ?? '').toString(),
              'description': (card['desc'] ?? '').toString(),
            };
          }).toList()
        : [
            {
              'icon': Icons.memory,
              'title': 'Controllers & Chargers',
              'description': 'High-performance controllers for smooth acceleration and intelligent chargers for fast energy replenishment.',
            },
            {
              'icon': Icons.electrical_services,
              'title': 'Motors & Parts',
              'description': 'Durable BLDC and PMSM motors designed for maximum torque and efficiency across all terrains.',
            },
            {
              'icon': Icons.battery_charging_full,
              'title': 'Lithium Batteries',
              'description': 'Long-life lithium-ion battery packs with advanced BMS for safety and reliability.',
            },
            {
              'icon': Icons.sensors,
              'title': 'Sensors & Wiring',
              'description': 'Precision throttle sensors, brake switches, and high-grade wiring harnesses for seamless connectivity.',
            },
            {
              'icon': Icons.tire_repair,
              'title': 'Tyres & Body Parts',
              'description': 'Rugged tyres for Indian roads and premium body panels for L3 and L5 vehicles.',
            },
            {
              'icon': Icons.handyman,
              'title': 'Consumables & Tools',
              'description': 'Professional-grade service tools, lubricants, and essential consumables for EV workshops.',
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
              SectionHeader(
                label: (widget.content['servicesTagline'] ?? '// GENUINE PARTS').toString().replaceAll('//', '').trim(),
                title: widget.content['servicesTitle'] ?? 'COMPLETE RANGE OF\nEV SPARES & TOOLS',
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
