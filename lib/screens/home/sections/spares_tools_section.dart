import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';

/// Brands We Serve - Header on white, Marquee on dark blue
/// Restored auto-scroll for all views as requested.
class BrandsCardSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const BrandsCardSection({super.key, required this.content});

  @override
  State<BrandsCardSection> createState() => _BrandsCardSectionState();
}

class _BrandsCardSectionState extends State<BrandsCardSection>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late Ticker _ticker;
  double _scrollPosition = 0.0;
  final double _speed = 100.0;

  final List<Map<String, dynamic>> _defaultItems = [
    {'name': 'Ola Electric', 'icon': Icons.electric_scooter, 'image': ''},
    {'name': 'TVS iQube', 'icon': Icons.two_wheeler, 'image': ''},
    {'name': 'Bajaj Chetak', 'icon': Icons.electric_moped, 'image': ''},
    {'name': 'Ather Energy', 'icon': Icons.bolt, 'image': ''},
    {'name': 'Hero Electric', 'icon': Icons.electric_bike, 'image': ''},
    {'name': 'Okinawa', 'icon': Icons.pedal_bike, 'image': ''},
    {'name': 'Ampere', 'icon': Icons.speed, 'image': ''},
    {'name': 'Revolt', 'icon': Icons.motorcycle, 'image': ''},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _ticker = createTicker((Duration elapsed) {
      if (!_scrollController.hasClients) return;

      _scrollPosition += _speed / 60;

      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll > 0 && _scrollPosition >= maxScroll / 2) {
        _scrollPosition = 0.0;
      }

      _scrollController.jumpTo(_scrollPosition);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ticker.start();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    final dynamic dynamicItems = widget.content['brandsCards'];
    final List<Map<String, dynamic>> items = (dynamicItems != null &&
            dynamicItems is List &&
            dynamicItems.isNotEmpty)
        ? dynamicItems.asMap().entries.map((e) {
            final card = e.value;
            final icons = [
              Icons.electric_scooter,
              Icons.two_wheeler,
              Icons.electric_moped,
              Icons.bolt,
              Icons.electric_bike,
              Icons.pedal_bike,
            ];
            return {
              'name': (card['title'] ?? '').toString(),
              'image': (card['image'] ?? '').toString(),
              'icon': icons[e.key % icons.length],
            };
          }).toList()
        : _defaultItems;

    return Column(
      children: [
        // Header on WHITE background
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(
            top: isMobile ? 50 : 80,
            bottom: 40,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Text(
                'GENUINE PARTS',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentTeal,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.content['brandsTitle'] ?? 'BRANDS WE SERVE',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.accentBlue,
                  fontSize: isMobile ? 28 : 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 50,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.accentBlue,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),

        // Marquee on DARK BLUE background
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.primaryNavy,
          ),
          child: SizedBox(
            height: 90,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length * 6,
              itemBuilder: (context, index) {
                final item = items[index % items.length];
                return _BrandItem(
                  name: item['name'] as String,
                  icon: item['icon'] as IconData,
                  imageUrl: item['image'] as String?,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final String? imageUrl;

  const _BrandItem({
    required this.name,
    required this.icon,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          hasImage
              ? Container(
                  width: 50,
                  height: 50,
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(icon, color: AppColors.accentTeal, size: 42);
                    },
                  ),
                )
              : Icon(icon, color: AppColors.accentTeal, size: 42),
          const SizedBox(width: 14),
          Text(
            name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
