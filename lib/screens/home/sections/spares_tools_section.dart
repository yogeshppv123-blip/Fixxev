import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';

class BrandsCardSection extends StatelessWidget {
  final Map<String, dynamic> content;

  const BrandsCardSection({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    // Dynamic Content
    final String sectionTitle = content['brandsTitle'] as String? ?? 'BRANDS WE SERVE';
    final List<dynamic> rawCards = content['brandsCards'] as List? ?? [];

    final List<Map<String, dynamic>> defaultItems = [
      {
        'id': '01',
        'title': 'Ola Electric',
        'description': 'Complete diagnostics, battery health check, and motor repairs for all Ola S1 and S1 Pro models.',
        'image': 'assets/images/brand_ola_new.png', 
        'icon': Icons.flash_on,
      },
      {
        'id': '02',
        'title': 'Ather Energy',
        'description': 'Specialized service for Ather 450X and 450 Plus, including belt tensioning and software updates.',
        'image': 'assets/images/brand_ola_new.png', // Placeholder if Ather missing
        'icon': Icons.electric_scooter,
      },
      {
        'id': '03',
        'title': 'TVS & More',
        'description': 'Expert care for TVS iQube, Bajaj Chetak, and other leading electric two-wheelers.',
        'image': 'assets/images/brand_tvs.png',
        'icon': Icons.handyman,
      },
    ];

    final List<Map<String, dynamic>> items = rawCards.isNotEmpty
        ? rawCards.map((c) => {
             'id': (c['id'] ?? '0${rawCards.indexOf(c) + 1}').toString(),
             'title': (c['title'] ?? '').toString(),
             'description': (c['desc'] ?? '').toString(),
             'image': (c['image'] ?? '').toString(),
             'icon': Icons.flash_on,
          }).toList()
        : defaultItems;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          // Section Header
          Text(
            'SERVICE EXPERTISE',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            sectionTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2.copyWith(
              color: AppColors.primaryNavy,
              height: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.accentBlue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 60),

          // Cards Row (Responsive)
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                 return Column(
                   children: items.map((item) => Padding(
                     padding: const EdgeInsets.only(bottom: 24),
                     child: _BrandCard(item: item),
                   )).toList(),
                 );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Fixed: changed from stretch to start
                  children: items.map((item) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _BrandCard(item: item),
                    ),
                  )).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _BrandCard extends StatefulWidget {
  final Map<String, dynamic> item;

  const _BrandCard({required this.item});

  @override
  State<_BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<_BrandCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final String imagePath = widget.item['image'];
    final bool isNetwork = imagePath.startsWith('http');

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.accentBlue : const Color(0xFFEBF2FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.transparent, // Clean look
            width: 2,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.accentBlue.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: 2,
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _isHovered ? Colors.white : AppColors.accentBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12), // Re-added padding for container consistency
                      child: isNetwork 
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (c,e,s) => Icon(widget.item['icon'], color: _isHovered ? AppColors.accentBlue : Colors.white, size: 32),
                            ),
                          )
                        : Image.asset(
                            imagePath,
                            // color: null, // Natural colors
                            fit: BoxFit.contain,
                            errorBuilder: (c,e,s) => Icon(widget.item['icon'], color: _isHovered ? AppColors.accentBlue : Colors.white, size: 32),
                          ),
                    ),
                  ),
                ),
                Text(
                  widget.item['id'] as String,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: _isHovered ? Colors.white.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              widget.item['title'] as String,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _isHovered ? Colors.white : AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.item['description'] as String,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: _isHovered ? Colors.white.withValues(alpha: 0.9) : AppColors.textDark.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
