import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';

class BrandsCardSection extends StatefulWidget {
  final Map<String, dynamic> content;

  const BrandsCardSection({super.key, required this.content});

  @override
  State<BrandsCardSection> createState() => _BrandsCardSectionState();
}

class _BrandsCardSectionState extends State<BrandsCardSection> {
  PageController? _pageController;
  int _currentIndex = 5001; // Large number for infinite loop, multiple of 3
  Timer? _autoPlayTimer;
  final int _realCount = 10000;
  bool? _lastIsMobile;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted && _pageController != null && _pageController!.hasClients) {
        _pageController!.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    
    // Initialize or Update Controller if screen mode changed
    if (_pageController == null || _lastIsMobile != isMobile) {
      _lastIsMobile = isMobile;
      final double viewportFraction = isMobile ? 1.0 : 0.333;
      final oldController = _pageController;
      
      _pageController = PageController(
        initialPage: _currentIndex, 
        viewportFraction: viewportFraction
      );
      
      // Dispose old controller after frame to avoid issues
      Future.delayed(Duration.zero, () => oldController?.dispose());
    }

    // Dynamic Content
    final String sectionTitle = widget.content['brandsTitle'] as String? ?? 'BRANDS WE SERVE';
    final List<dynamic> rawCards = widget.content['brandsCards'] as List? ?? [];

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
        'image': 'assets/images/brand_ola_new.png',
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
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
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
              ],
            ),
          ),
          const SizedBox(height: 60),

          SizedBox(
            height: 380,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: items.isEmpty ? 0 : _realCount,
              itemBuilder: (context, index) {
                final item = items[index % items.length];
                return AnimatedPadding(
                  duration: const Duration(milliseconds: 500),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 15,
                    vertical: (_currentIndex == index) ? 0 : (isMobile ? 0 : 20),
                  ),
                  child: _BrandCard(item: item, isActive: _currentIndex == index),
                );
              },
            ),
          ),

          const SizedBox(height: 40),
          if (items.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
                (index) => GestureDetector(
                  onTap: () {
                    final int currentMod = _currentIndex % items.length;
                    final int diff = index - currentMod;
                    _pageController?.animateToPage(
                      _currentIndex + diff,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: (_currentIndex % items.length) == index ? 30 : 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: (_currentIndex % items.length) == index 
                          ? AppColors.secondary 
                          : AppColors.textMuted.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BrandCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isActive;

  const _BrandCard({required this.item, required this.isActive});

  @override
  State<_BrandCard> createState() => _BrandCardState();
}

class _BrandCardState extends State<_BrandCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final String imagePath = widget.item['image'];
    final bool isNetwork = imagePath.startsWith('http');
    final bool highlighted = _isHovered || widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.accentBlue : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: highlighted
              ? [
                  BoxShadow(
                    color: AppColors.accentBlue.withOpacity(0.25),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: highlighted ? Colors.white : AppColors.accentBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: isNetwork 
                    ? Image.network(
                        imagePath, 
                        fit: BoxFit.contain, 
                        // REMOVED COLOR FILTER HERE
                        errorBuilder: (c,e,s) => Icon(widget.item['icon'], color: highlighted ? AppColors.accentBlue : Colors.white)
                      )
                    : Image.asset(
                        imagePath, 
                        fit: BoxFit.contain,
                        // REMOVED COLOR FILTER HERE
                        errorBuilder: (c,e,s) => Icon(widget.item['icon'], color: highlighted ? AppColors.accentBlue : Colors.white)
                      ),
                ),
                Text(
                  widget.item['id'],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: highlighted ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.05),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              widget.item['title'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: highlighted ? Colors.white : AppColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                widget.item['description'],
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: highlighted ? Colors.white.withOpacity(0.9) : AppColors.textDark.withOpacity(0.6),
                ),
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
