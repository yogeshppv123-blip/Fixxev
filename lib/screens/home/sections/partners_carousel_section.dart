import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';

/// Partners carousel section with auto-play scrolling
class PartnersCarouselSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const PartnersCarouselSection({super.key, required this.content});

  @override
  State<PartnersCarouselSection> createState() => _PartnersCarouselSectionState();
}

class _PartnersCarouselSectionState extends State<PartnersCarouselSection> {
  late ScrollController _scrollController;
  late double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Auto-scroll logic
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      _scrollPosition += 1.0;
      if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
        _scrollPosition = 0.0;
        _scrollController.jumpTo(0.0);
      } else {
        _scrollController.animateTo(
          _scrollPosition,
          duration: const Duration(milliseconds: 30),
          curve: Curves.linear,
        );
      }
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> dynamicPartners = widget.content['partnerLogos'] ?? [];
    
    final partners = dynamicPartners.isNotEmpty 
      ? dynamicPartners.map((p) => {
          'name': (p['name'] ?? '').toString(),
          'image': (p['image'] ?? '').toString(),
          'icon': Icons.bolt, // Fallback if no image
        }).toList()
      : [
          {'name': 'EV CORE', 'icon': Icons.bolt},
          {'name': 'BATTERIX', 'icon': Icons.battery_full},
          {'name': 'AUTOFLOW', 'icon': Icons.auto_mode},
          {'name': 'GRIDTECH', 'icon': Icons.grid_view},
          {'name': 'NEXCHARGE', 'icon': Icons.cable},
          {'name': 'E-DRIVE', 'icon': Icons.speed},
        ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
      ),
      child: Column(
        children: [
          Text(
            widget.content['partnersTitle'] ?? 'OUR TRUSTED PARTNERS',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 3.0,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryNavy.withAlpha(180),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 60,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 20,
              itemBuilder: (context, index) {
                final partner = partners[index % partners.length];
                return _PartnerLogo(
                  name: partner['name'] as String, 
                  icon: partner['icon'] as IconData?,
                  imageUrl: partner['image'] as String?,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PartnerLogo extends StatefulWidget {
  final String name;
  final IconData? icon;
  final String? imageUrl;

  const _PartnerLogo({required this.name, this.icon, this.imageUrl});

  @override
  State<_PartnerLogo> createState() => _PartnerLogoState();
}

class _PartnerLogoState extends State<_PartnerLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        transform: Matrix4.identity()..scale(_isHovered ? 1.1 : 1.0),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isHovered 
              ? [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 4))] 
              : [],
        ),
        child: Row(
          children: [
            if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
              Image.network(
                widget.imageUrl!,
                height: 32,
                errorBuilder: (context, error, stackTrace) => Icon(widget.icon ?? Icons.business, color: AppColors.accentRed, size: 28),
              )
            else
              Icon(
                widget.icon ?? Icons.business,
                color: AppColors.accentRed,
                size: 28,
              ),
            const SizedBox(width: 12),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryNavy,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
