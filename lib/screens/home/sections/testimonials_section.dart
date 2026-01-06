import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';

class TestimonialsSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const TestimonialsSection({super.key, required this.content});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 5001; // Start at a multiple of 3
  Timer? _autoPlayTimer;
  final int _realCount = 10000;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool? _lastIsMobile;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && _pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    
    if (_lastIsMobile != isMobile) {
      _lastIsMobile = isMobile;
      final double viewportFraction = isMobile ? 1.0 : 0.333;
      _pageController = PageController(initialPage: _currentIndex, viewportFraction: viewportFraction);
    }

    final dynamic dynamicTestimonials = widget.content['testimonials'];
    final List<Map<String, dynamic>> testimonials = (dynamicTestimonials != null && dynamicTestimonials is List && dynamicTestimonials.isNotEmpty)
        ? dynamicTestimonials.map((t) => {
            'name': (t['name'] ?? '').toString(),
            'role': (t['role'] ?? '').toString(),
            'content': (t['content'] ?? '').toString(),
            'rating': int.tryParse(t['rating']?.toString() ?? '5') ?? 5,
            'image': (t['image'] ?? '').toString(),
          }).toList()
        : [
            {
              'name': 'Rahul Sharma',
              'role': 'Tesla Owner',
              'content': 'The AIOT diagnostics at FIXXEV saved me from a major battery failure. The real-time monitoring is mind-blowing!',
              'rating': 5,
              'image': '',
            },
            {
              'name': 'Ananya Patel',
              'role': 'Nexon EV User',
              'content': 'Top-notch service! The technicians really know their way around electric vehicles. Highly recommended for EV owners.',
              'rating': 5,
              'image': '',
            },
            {
              'name': 'Vikram Singh',
              'role': 'Fleet Manager',
              'content': 'We moved our entire EV fleet maintenance to FIXXEV. Their proactive support has increased our vehicle uptime by 40%.',
              'rating': 5,
              'image': '',
            },
          ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100),
      color: AppColors.white,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Text('// TESTIMONIALS', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 16),
            Text(
              widget.content['testimonialsTitle'] ?? 'WHAT OUR CLIENTS SAY\nABOUT OUR SERVICES',
              style: isMobile
                  ? AppTextStyles.sectionTitle.copyWith(fontSize: 26)
                  : AppTextStyles.sectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            
            SizedBox(
              height: 420,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: testimonials.isEmpty ? 0 : _realCount,
                itemBuilder: (context, index) {
                  final t = testimonials[index % testimonials.length];
                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 500),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 15 : 20,
                      vertical: (_currentIndex == index) ? 0 : (isMobile ? 0 : 30),
                    ),
                    child: _AnimatedTestimonialCard(
                      name: t['name'] as String,
                      role: t['role'] as String,
                      content: t['content'] as String,
                      rating: t['rating'] as int,
                      image: t['image'] as String,
                      isActive: _currentIndex == index,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 40),
            if (testimonials.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  testimonials.length,
                  (index) => GestureDetector(
                    onTap: () {
                      final int currentMod = _currentIndex % testimonials.length;
                      final int diff = index - currentMod;
                      _pageController.animateToPage(
                        _currentIndex + diff,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: (_currentIndex % testimonials.length) == index ? 30 : 10,
                      height: 10,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: (_currentIndex % testimonials.length) == index 
                            ? AppColors.accentRed 
                            : AppColors.textMuted.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedTestimonialCard extends StatefulWidget {
  final String name;
  final String role;
  final String content;
  final int rating;
  final String image;
  final bool isActive;

  const _AnimatedTestimonialCard({
    required this.name,
    required this.role,
    required this.content,
    required this.rating,
    required this.image,
    required this.isActive,
  });

  @override
  State<_AnimatedTestimonialCard> createState() => _AnimatedTestimonialCardState();
}

class _AnimatedTestimonialCardState extends State<_AnimatedTestimonialCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final highlighted = _isHovered || widget.isActive;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.primaryNavy : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: highlighted ? AppColors.accentRed : AppColors.textMuted.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: highlighted 
                  ? AppColors.accentRed.withOpacity(0.1) 
                  : Colors.black.withOpacity(0.03),
              blurRadius: highlighted ? 30 : 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.format_quote,
                  size: 40,
                  color: highlighted ? AppColors.accentRed : AppColors.accentRed.withOpacity(0.2),
                ),
                if (widget.image.isNotEmpty)
                   Container(
                     width: 50,
                     height: 50,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       border: Border.all(color: AppColors.accentRed, width: 2),
                     ),
                     clipBehavior: Clip.antiAlias,
                     child: Image.network(widget.image, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.person)),
                   ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  Icons.star,
                  size: 16,
                  color: index < widget.rating ? Colors.amber : Colors.grey.shade300,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Text(
                '\"${widget.content}\"',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: highlighted ? AppColors.textLight : AppColors.textDark,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
                overflow: TextOverflow.fade,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.accentRed,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 16,
                    color: highlighted ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.role,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: highlighted ? AppColors.textGrey : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
