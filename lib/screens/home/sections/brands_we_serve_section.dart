import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';

/// Brands We Serve section with auto-play scrolling
class BrandsWeServeSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const BrandsWeServeSection({super.key, required this.content});

  @override
  State<BrandsWeServeSection> createState() => _BrandsWeServeSectionState();
}

class _BrandsWeServeSectionState extends State<BrandsWeServeSection> {
  late ScrollController _scrollController;
  late double _scrollPosition = 0.0;
  bool _isDisposed = false;

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
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_isDisposed || !mounted) return;
      
      if (_scrollController.hasClients) {
          _scrollPosition += 1.0;
          if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
            _scrollPosition = 0.0;
            _scrollController.jumpTo(0.0);
          } else {
            _scrollController.animateTo(
              _scrollPosition,
              duration: const Duration(milliseconds: 50),
              curve: Curves.linear,
            );
          }
      }
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We could add a dynamic field specifically for brands later if needed.
    // For now, we'll default to these unless 'brandsWeServe' is in content.
    final List<dynamic> dynamicBrands = widget.content['brandsWeServe'] ?? [];
    
    // Hardcoded defaults with local assets
    final defaultBrands = [
          {'name': 'OLA ELECTRIC', 'image': 'assets/images/brand_ola_new.png'},
          {'name': 'ATHER ENERGY', 'image': 'assets/images/brand_ola_new.png'}, // Placeholder
          {'name': 'TVS iQUBE', 'image': 'assets/images/brand_tvs.png'},
          {'name': 'HERO ELECTRIC', 'image': 'assets/images/brand_tvs.png'}, // Placeholder
          {'name': 'BAJAJ CHETAK', 'image': 'assets/images/brand_bajaj.png'},
          {'name': 'AMPERE', 'image': 'assets/images/brand_bajaj.png'}, // Placeholder
          {'name': 'OKINAWA', 'image': 'assets/images/brand_ola_new.png'}, // Placeholder
    ];

    List<dynamic> brands = dynamicBrands.isNotEmpty 
      ? dynamicBrands.map((b) => {
          'name': (b['name'] ?? '').toString(),
          'image': (b['image'] ?? '').toString(),
        }).toList()
      : defaultBrands;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: const Color(0xFFF8F9FA), // Light grey background for section
      child: Column(
        children: [
          Text(
            'BRANDS WE SERVE',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 2.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryNavy.withAlpha(150),
            ),
          ),
          const SizedBox(height: 12),
          Text(
             'Expert Diagnostics & Repair for All Leading EV Brands',
             textAlign: TextAlign.center,
             style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 60),
          SizedBox(
            height: 140, // Height for card
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: brands.length * 3,
              itemBuilder: (context, index) {
                final brand = brands[index % brands.length];
                return _BrandLogo(
                  name: brand['name'] as String, 
                  imageUrl: brand['image'] as String?,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandLogo extends StatefulWidget {
  final String name;
  final String? imageUrl;

  const _BrandLogo({required this.name, this.imageUrl});

  @override
  State<_BrandLogo> createState() => _BrandLogoState();
}

class _BrandLogoState extends State<_BrandLogo> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        width: 180, // Fixed width card
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
             BoxShadow(
               color: Colors.black.withOpacity(0.06), 
               blurRadius: 15, 
               offset: const Offset(0, 5)
             )
          ],
          border: Border.all(
            color: _isHovered ? AppColors.accentBlue : Colors.transparent, 
            width: 1.5
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             // Logo Image
             Expanded(
               child: (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                 ? (widget.imageUrl!.startsWith('http') 
                      ? Image.network(widget.imageUrl!, fit: BoxFit.contain)
                      : Image.asset(
                          widget.imageUrl!, 
                          fit: BoxFit.contain,
                          errorBuilder: (c,e,s) => const Icon(Icons.bolt, size: 40, color: Colors.grey)
                        ))
                 : const Icon(Icons.bolt, size: 40, color: Colors.grey),
             ),
             const SizedBox(height: 12),
             // Brand Name
             Text(
               widget.name,
               textAlign: TextAlign.center,
               maxLines: 1,
               overflow: TextOverflow.ellipsis,
               style: TextStyle(
                 fontSize: 13,
                 fontWeight: FontWeight.w700,
                 color: _isHovered ? AppColors.accentBlue : AppColors.primaryNavy,
               ),
             ),
          ],
        ),
      ),
    );
  }
}
