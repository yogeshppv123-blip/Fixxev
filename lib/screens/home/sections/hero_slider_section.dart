import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';

/// Hero Carousel section with high-quality 4K background images - Ken Burns Zoom Effect
class HeroSliderSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const HeroSliderSection({super.key, required this.content});

  @override
  State<HeroSliderSection> createState() => _HeroSliderSectionState();
}

class _HeroSliderSectionState extends State<HeroSliderSection>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoPlayTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // Animation for Ken Burns Effect
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  final List<Map<String, String>> _slides = [
    {
      'image': 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80',
      'tagline': 'LAUNCH ANNOUNCEMENT',
      'title': 'Driving India’s EV Future ⚡',
      'subtitle': 'Fixx EV is solving the biggest barriers to electric vehicle adoption in India — reliable after-sales service and spares availability.',
      'buttonText': 'JOIN THE MISSION',
    },
    {
      'image': 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80',
      'tagline': 'SERVICE ECOSYSTEM',
      'title': '500+ Authorized Service Centres',
      'subtitle': 'We are building a nationwide, standardized EV after-sales network across key cities and towns in India.',
      'buttonText': 'FRANCHISE OPPORTUNITY',
    },
    {
      'image': 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80',
      'tagline': 'TECHNOLOGY BACKBONE',
      'title': 'Seamless Ownership Experience',
      'subtitle': 'Our mobile application connects EV owners to authorized service centres for bookings, diagnostics, and real-time support.',
      'buttonText': 'DOWNLOAD THE APP',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.content.containsKey('heroTitle')) {
      _slides[0]['title'] = widget.content['heroTitle']!;
    }
    if (widget.content.containsKey('heroSubtitle')) {
      _slides[0]['subtitle'] = widget.content['heroSubtitle']!;
    }
    if (widget.content.containsKey('heroImage') && widget.content['heroImage']!.isNotEmpty) {
      _slides[0]['image'] = widget.content['heroImage']!;
    }
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // Ken Burns Effect Controller - very slow zoom
    _zoomController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);
    
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.linear),
    );

    _fadeController.forward();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (mounted) {
        final nextIndex = (_currentIndex + 1) % _slides.length;
        _pageController.animateToPage(
          nextIndex,
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
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SizedBox(
      height: isMobile ? screenHeight * 0.85 : screenHeight * 0.95,
      width: double.infinity,
      child: Stack(
        children: [
          // Background Image Carousel with Ken Burns Effect
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _fadeController.reset();
              _fadeController.forward();
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return ScaleTransition(
                scale: _zoomAnimation,
                child: _buildSlideBackground(index),
              );
            },
          ),
          // Gradient Overlay - Lighter with blur
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.25),
                    Colors.black.withOpacity(0.1),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          // Diagonal red accent
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _DiagonalClipper(),
              child: Container(
                height: 120,
                decoration: const BoxDecoration(
                  gradient: AppColors.redGradient,
                ),
              ),
            ),
          ),
          // Floating service icons (desktop only)
          if (!isMobile)
            Positioned(
              right: 80,
              top: screenHeight * 0.2,
              child: _buildFloatingIcons(),
            ),
          // Main content
          Positioned.fill(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildContent(isMobile),
            ),
          ),
          // Social links (desktop only)
          if (!isMobile)
            Positioned(
              left: 30,
              top: screenHeight * 0.35,
              child: _buildSocialLinks(),
            ),
          // Carousel indicators
          Positioned(
            bottom: 150,
            left: isMobile ? 24 : 80,
            child: _buildCarouselIndicators(),
          ),
          // Navigation arrows (desktop only)
          if (!isMobile)
            Positioned(
              right: 80,
              bottom: 150,
              child: Row(
                children: [
                  _buildNavButton(Icons.arrow_back_ios_new, _previousSlide),
                  const SizedBox(width: 12),
                  _buildNavButton(Icons.arrow_forward_ios, _nextSlide),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSlideBackground(int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          _slides[index]['image']!,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(color: AppColors.primaryNavy);
          },
        ),
        // Slight blur effect
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  Widget _buildContent(bool isMobile) {
    final slide = _slides[_currentIndex];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.accentBlue, // Changed to Sky Blue to match image
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                slide['tagline']!.toUpperCase(),
                style: AppTextStyles.heroTagline.copyWith(
                  color: AppColors.textLight.withAlpha(200),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              key: ValueKey(_currentIndex),
              width: isMobile ? double.infinity : 700,
              child: Text(
                slide['title']!,
                style: isMobile
                    ? AppTextStyles.heroTitle.copyWith(fontSize: 36)
                    : AppTextStyles.heroTitle.copyWith(fontSize: 56),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: isMobile ? double.infinity : 520,
            child: Text(
              slide['subtitle']!,
              style: AppTextStyles.heroSubtitle.copyWith(
                fontSize: isMobile ? 14 : 16,
              ),
            ),
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            text: slide['buttonText']!,
            icon: Icons.arrow_forward,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcons() {
    return Column(
      children: [
        _floatingIconItem(Icons.settings_suggest, 'Diagnostics'),
        const SizedBox(height: 20),
        _floatingIconItem(Icons.battery_charging_full, 'Battery'),
        const SizedBox(height: 20),
        _floatingIconItem(Icons.build_circle, 'Repairs'),
      ],
    );
  }

  Widget _floatingIconItem(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Column(
      children: [
        _socialIcon(Icons.facebook),
        const SizedBox(height: 14),
        _socialIcon(Icons.camera_alt_outlined),
        const SizedBox(height: 14),
        _socialIcon(Icons.link),
      ],
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.textLight.withAlpha(15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.textLight.withAlpha(25)),
      ),
      child: Icon(icon, color: AppColors.textLight, size: 20),
    );
  }

  Widget _buildCarouselIndicators() {
    return Row(
      children: List.generate(
        _slides.length,
        (index) => GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _currentIndex == index ? 48 : 16,
            height: 5,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: _currentIndex == index
                  ? AppColors.secondary // Mint Green for active indicator
                  : AppColors.textLight.withAlpha(60),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return Material(
      color: AppColors.accentRed.withAlpha(200),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 52,
          height: 52,
          child: Icon(icon, color: AppColors.textLight, size: 20),
        ),
      ),
    );
  }

  void _previousSlide() {
    final prevIndex = (_currentIndex - 1 + _slides.length) % _slides.length;
    _pageController.animateToPage(
      prevIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void _nextSlide() {
    final nextIndex = (_currentIndex + 1) % _slides.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }
}

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height * 0.65);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
