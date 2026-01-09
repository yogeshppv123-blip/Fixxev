import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/section_header.dart';
import 'package:go_router/go_router.dart';

/// Services section with flexible layout that adjusts to content.
/// No more fixed aspect ratios to prevent overflows.
/// Disabled animations for mobile users.
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

    final dynamic dynamicServices = widget.content['serviceCards'];
    final List<Map<String, dynamic>> services = (dynamicServices != null && dynamicServices is List && dynamicServices.isNotEmpty)
        ? dynamicServices.asMap().entries.map((e) {
            final card = e.value;
            final icons = [Icons.memory, Icons.electrical_services, Icons.battery_charging_full, Icons.sensors, Icons.tire_repair, Icons.handyman];
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

    Widget body = Column(
      children: [
        SectionHeader(
          label: (widget.content['servicesTagline'] ?? '// GENUINE PARTS').toString().replaceAll('//', '').trim(),
          title: widget.content['servicesTitle'] ?? 'COMPLETE RANGE OF\nEV SPARES & TOOLS',
        ),
        const SizedBox(height: 60),
        
        isMobile 
          ? Column(
              children: services.map((service) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _ServiceCard(
                  icon: service['icon'] as IconData,
                  title: service['title'] as String,
                  description: service['description'] as String,
                  onTap: () => context.go('/services'),
                ),
              )).toList(),
            )
          : Wrap(
              spacing: 24,
              runSpacing: 24,
              children: services.map((service) => SizedBox(
                width: (screenWidth - 160 - 48) / 3, // 3 columns calculation
                child: _ServiceCard(
                  icon: service['icon'] as IconData,
                  title: service['title'] as String,
                  description: service['description'] as String,
                  onTap: () => context.go('/services'),
                ),
              )).toList(),
            ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: isMobile ? 60 : 100,
      ),
      color: AppColors.backgroundLight,
      child: isMobile 
        ? body
        : FadeTransition(
            opacity: _fadeAnimation,
            child: body,
          ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..translate(0.0, (!isMobile && _isHovered) ? -10.0 : 0.0),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: (!isMobile && _isHovered) ? AppColors.primaryNavy : AppColors.primaryNavy.withAlpha(15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (!isMobile && _isHovered) ? AppColors.accentRed : AppColors.primaryNavy.withAlpha(30),
              width: (!isMobile && _isHovered) ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (!isMobile && _isHovered) ? AppColors.accentRed.withAlpha(40) : Colors.black.withAlpha(10),
                blurRadius: (!isMobile && _isHovered) ? 40 : 20,
                offset: Offset(0, (!isMobile && _isHovered) ? 20 : 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: AppColors.accentRed,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(widget.icon, color: AppColors.white, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                widget.title,
                style: AppTextStyles.cardTitle.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: (!isMobile && _isHovered) ? AppColors.textLight : AppColors.primaryNavy,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.description,
                style: AppTextStyles.cardDescription.copyWith(
                  fontSize: 15,
                  height: 1.5,
                  color: (!isMobile && _isHovered) ? AppColors.textLight.withAlpha(200) : AppColors.textDark.withAlpha(180),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    color: (!isMobile && _isHovered) ? AppColors.white : AppColors.primaryNavy,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
