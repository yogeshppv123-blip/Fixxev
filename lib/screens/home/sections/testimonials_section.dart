import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:google_fonts/google_fonts.dart';

class TestimonialsSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const TestimonialsSection({super.key, required this.content});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection>
    with TickerProviderStateMixin {
  int _activeIndex = 0;
  Timer? _autoplayTimer;
  double _containerWidth = 1200;

  @override
  void initState() {
    super.initState();
    _startAutoplay();
  }

  void _startAutoplay() {
    _autoplayTimer?.cancel();
    _autoplayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) _handleNext();
    });
  }

  void _handleNext() {
    final dynamic dynamicTestimonials = widget.content['testimonials'];
    final len = (dynamicTestimonials as List?)?.length ?? 2;
    if (len == 0) return;
    setState(() {
      _activeIndex = (_activeIndex + 1) % len;
    });
  }

  void _handlePrev() {
    final dynamic dynamicTestimonials = widget.content['testimonials'];
    final len = (dynamicTestimonials as List?)?.length ?? 2;
    if (len == 0) return;
    setState(() {
      _activeIndex = (_activeIndex - 1 + len) % len;
    });
  }

  double _calculateGap(double width) {
    const minWidth = 1024.0;
    const maxWidth = 1456.0;
    const minGap = 60.0;
    const maxGap = 86.0;
    if (width <= minWidth) return minGap;
    if (width >= maxWidth) return (maxGap + 0.06018 * (width - maxWidth)).clamp(minGap, 200.0);
    return minGap + (maxGap - minGap) * ((width - minWidth) / (maxWidth - minWidth));
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1000;
    
    final dynamic dynamicTestimonials = widget.content['testimonials'];
    final List<Map<String, dynamic>> testimonials = (dynamicTestimonials != null && dynamicTestimonials is List && dynamicTestimonials.isNotEmpty)
        ? dynamicTestimonials.map((t) => {
            'name': (t['name'] ?? '').toString(),
            'role': (t['role'] ?? '').toString(),
            'content': (t['content'] ?? '').toString(),
            'image': (t['image'] ?? '').toString(),
          }).toList()
        : [
            {
              'name': 'Rahul Sharma',
              'role': 'Zomato Delivery Partner',
              'content': 'The AIOT diagnostics at FIXXEV saved me from a major battery failure. Truly impressive tech!',
              'image': 'https://res.cloudinary.com/dqr6m8v7f/image/upload/v1/fixxev/testimonials/rahul_sharma',
            },
            {
              'name': 'Ananya Patel',
              'role': 'Ather User',
              'content': 'Top-notch service! The technicians really know their way around electric vehicles. Highly recommend.',
              'image': 'https://res.cloudinary.com/dqr6m8v7f/image/upload/v1/fixxev/testimonials/ananya_patel',
            },
            {
              'name': 'Amit Kumar',
              'role': 'Fleet Manager',
              'content': 'Fast service, honest support, and now I\'m earning more without stress. Best in the business.',
              'image': 'https://images.unsplash.com/photo-1512316609839-ce289d3eba0a?q=80&w=1368&auto=format&fit=crop',
            },
          ];

    if (testimonials.isEmpty) return const SizedBox.shrink();
    final activeTestimonial = testimonials[_activeIndex % testimonials.length];

    return Container(
      width: double.infinity,
      color: const Color(0xFFF7F7FA),
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 30, horizontal: isMobile ? 20 : 40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                "WHAT OUR CLIENTS SAY",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2EBD59),
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Real Stories from Real Users",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: isMobile ? 32 : 52,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentBlue,
                  height: 1.1,
                ),
              ),
              SizedBox(height: isMobile ? 40 : 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  _containerWidth = constraints.maxWidth;
                  if (isMobile) {
                    return Column(
                      children: [
                         _buildMobileImage(activeTestimonial['image']),
                         const SizedBox(height: 30),
                         _buildMobileContent(activeTestimonial),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 1, child: _buildImageStack(testimonials, isMobile)),
                      const SizedBox(width: 80),
                      Expanded(flex: 1, child: _buildContent(activeTestimonial, isMobile)),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileImage(String imageUrl) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.person, size: 50),
        ),
      ),
    );
  }

  Widget _buildMobileContent(Map<String, dynamic> testimonial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.format_quote_rounded, size: 50, color: AppColors.accentBlue.withOpacity(0.5)),
        Text(
          testimonial['name'],
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.accentBlue,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          testimonial['role'],
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          testimonial['content'],
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            _buildArrowButton(Icons.arrow_back, _handlePrev),
            const SizedBox(width: 16),
            _buildArrowButton(Icons.arrow_forward, _handleNext),
          ],
        ),
      ],
    );
  }

  Widget _buildImageStack(List<Map<String, dynamic>> testimonials, bool isMobile) {
    final gap = _calculateGap(_containerWidth);
    final stickUp = gap * 0.8;
    final len = testimonials.length;

    final List<int> sortedIndices = List.generate(len, (i) => i);
    sortedIndices.sort((a, b) {
      int zA = (a == _activeIndex) ? 3 : (a == (_activeIndex - 1 + len) % len || a == (_activeIndex + 1) % len) ? 2 : 1;
      int zB = (b == _activeIndex) ? 3 : (b == (_activeIndex - 1 + len) % len || b == (_activeIndex + 1) % len) ? 2 : 1;
      return zA.compareTo(zB);
    });

    return Container(
      height: 550,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: sortedIndices.map((index) {
          final bool isActive = index == _activeIndex;
          final bool isLeft = (index == (_activeIndex - 1 + len) % len);
          final bool isRight = (index == (_activeIndex + 1) % len);

          double translateX = 0;
          double translateY = 0;
          double scale = 0.5;
          double opacity = 0;
          double rotateY = 0;

          if (isActive) {
            scale = 1.0;
            opacity = 1.0;
          } else if (isLeft) {
            translateX = -gap * 0.75;
            translateY = -stickUp * 1.2;
            scale = 0.9;
            opacity = 0.95;
            rotateY = 0.4; 
          } else if (isRight) {
            translateX = gap * 0.75;
            translateY = -stickUp * 1.2;
            scale = 0.9;
            opacity = 0.95;
            rotateY = -0.4; 
          }

          return AnimatedContainer(
            key: ValueKey('item_$index'),
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translate(translateX, translateY)
              ..scale(scale)
              ..rotateY(rotateY),
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: opacity,
              child: Container(
                width: 480,
                height: 320,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isActive ? 0.25 : 0.15),
                      blurRadius: isActive ? 40 : 20,
                      offset: Offset(0, isActive ? 20 : 10),
                    )
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: isActive ? 0 : 4, sigmaY: isActive ? 0 : 4),
                  child: Image.network(
                    testimonials[index]['image'],
                    fit: BoxFit.cover,
                    color: isActive ? null : Colors.black.withOpacity(0.4),
                    colorBlendMode: isActive ? null : BlendMode.darken,
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.person, size: 50),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> testimonial, bool isMobile) {
    return Container(
      height: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Column(
              key: ValueKey(_activeIndex),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Icon(Icons.format_quote_rounded, size: 50, color: AppColors.accentBlue),
                ),
                Text(
                  testimonial['name'],
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.accentBlue,
                    height: 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  testimonial['role'],
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                _AnimatedQuote(text: testimonial['content']),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                _buildArrowButton(Icons.arrow_back, _handlePrev),
                const SizedBox(width: 16),
                _buildArrowButton(Icons.arrow_forward, _handleNext),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          onTap();
          _startAutoplay();
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xFF141414),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class _AnimatedQuote extends StatelessWidget {
  final String text;
  const _AnimatedQuote({required this.text});

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    return Wrap(
      children: List.generate(words.length, (index) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Text(
                  words[index],
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
