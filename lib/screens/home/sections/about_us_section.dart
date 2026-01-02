import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:fixxev/widgets/section_header.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';
import 'package:go_router/go_router.dart';

/// About Us section with animations triggered when in view and hover effects
class AboutUsSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const AboutUsSection({super.key, required this.content});

  @override
  State<AboutUsSection> createState() => _AboutUsSectionState();
}

class _AboutUsSectionState extends State<AboutUsSection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _statsController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideLeftAnimation;
  late Animation<Offset> _slideRightAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideLeftAnimation = Tween<Offset>(
      begin: const Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _slideRightAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Start only the basic entrance animation immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    final visible = visibilityInfo.visibleFraction > 0.3;
    if (visible && !_isVisible) {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
      _statsController.forward(from: 0.0);
    } else if (visibilityInfo.visibleFraction < 0.1) {
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _statsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return VisibilityDetector(
      key: const Key('about_us_section'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white, // Clean white background
        ),
        child: Stack(
          children: [
            // Animated diagonal red accent
            Positioned(
              top: 0,
              left: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: CustomPaint(
                      size: Size(screenWidth * 0.6, 400),
                      painter: _DiagonalAccentPainter(),
                    ),
                  );
                },
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 80,
                vertical: 100,
              ),
              child: isMobile
                  ? _buildMobileLayout()
                  : _buildDesktopLayout(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left - Image placeholder with animation
        Expanded(
          flex: 5,
          child: SlideTransition(
            position: _slideLeftAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _AnimatedImageSection(),
            ),
          ),
        ),
        const SizedBox(width: 60),
        // Right - Content with animation
        Expanded(
          flex: 5,
          child: SlideTransition(
            position: _slideRightAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildContentSection(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          _buildContentSection(),
          const SizedBox(height: 40),
          _buildStatsGrid(),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          label: widget.content['aboutLabel'] ?? 'ANNOUNCING MISSION 500',
          title: widget.content['aboutTitle'] ?? "SOLVING INDIA’S EV\nAFTER-SALES GAP",
          isLight: false, // Dark text on white bg
          centered: false,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: 32),
        _buildRichText(
          widget.content['aboutDesc1'] ?? '**Fixx EV Technologies Pvt. Ltd.** is on a mission to solve one of the biggest barriers to electric vehicle adoption in India — **reliable after-sales service and spares availability**.'
        ),
        const SizedBox(height: 24),
        _buildRichText(
          widget.content['aboutDesc2'] ?? 'We are building a nationwide, standardized EV after-sales network by appointing **500 Fixx EV Authorized Franchise Service Centres** across key cities and towns in India.'
        ),
        const SizedBox(height: 12),
        if (widget.content['aboutDesc3'] != null)
          _buildRichText(widget.content['aboutDesc3']!),
        const SizedBox(height: 48),
        PrimaryButton(
          text: 'READ MORE',
          onPressed: () => context.go('/about'),
          icon: Icons.arrow_forward,
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _AnimatedStatBox(
                value: 500,
                suffix: '+',
                label: 'Service Centres',
                delay: 0,
                controller: _statsController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _AnimatedStatBox(
                value: 20,
                suffix: '+',
                label: 'Years Experience',
                delay: 500,
                controller: _statsController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _AnimatedStatBox(
                value: 200,
                suffix: '+',
                label: 'Planned Cities',
                delay: 1000,
                controller: _statsController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _AnimatedStatBox(
                value: 100,
                suffix: '%',
                label: 'Quality Control',
                delay: 1500,
                controller: _statsController,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Animated image section with hover effect
class _AnimatedImageSection extends StatefulWidget {
  @override
  State<_AnimatedImageSection> createState() => _AnimatedImageSectionState();
}

class _AnimatedImageSectionState extends State<_AnimatedImageSection> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutQuart,
        height: 500,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -10.0 : 0.0),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'),
            fit: BoxFit.cover,
            opacity: 0.7,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered 
                  ? AppColors.accentRed.withAlpha(50) 
                  : Colors.black.withAlpha(30),
              blurRadius: _isHovered ? 50 : 30,
              offset: Offset(0, _isHovered ? 25 : 15),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.primaryNavy.withAlpha(200),
              ],
            ),
          ),
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accentRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ENGINEERING HUB',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Next-Gen EV\nService Infrastructure',
                style: AppTextStyles.cardTitle.copyWith(
                  color: Colors.white,
                  fontSize: 28,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  Widget _buildRichText(String text) {
    List<TextSpan> spans = [];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (partHighlight(i)) {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
        ));
      } else {
        spans.add(TextSpan(text: parts[i]));
      }
    }
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6, fontSize: 16),
        children: spans,
      ),
    );
  }

  bool partHighlight(int index) => index % 2 == 1;

/// Animated stat box with counter animation and hover effect
class _AnimatedStatBox extends StatefulWidget {
  final int value;
  final String suffix;
  final String label;
  final int delay;
  final AnimationController controller;

  const _AnimatedStatBox({
    required this.value,
    required this.suffix,
    required this.label,
    required this.delay,
    required this.controller,
  });

  @override
  State<_AnimatedStatBox> createState() => _AnimatedStatBoxState();
}

class _AnimatedStatBoxState extends State<_AnimatedStatBox>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late Animation<double> _countAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _countAnimation = Tween<double>(begin: 0, end: widget.value.toDouble())
        .animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(
        widget.delay / 3000,
        (widget.delay + 1500) / 3000,
        curve: Curves.easeOutCubic,
      ),
    ));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: Interval(
          widget.delay / 3000,
          (widget.delay + 500) / 3000,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -5.0 : 0.0),
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
              decoration: BoxDecoration(
                color: _isHovered 
                    ? AppColors.accentRed.withAlpha(30) 
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered 
                      ? AppColors.accentRed 
                      : AppColors.textLight.withAlpha(20),
                  width: _isHovered ? 2 : 1,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.accentRed.withAlpha(30),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _countAnimation.value.toInt().toString(),
                        style: AppTextStyles.statNumber.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.suffix,
                          style: AppTextStyles.statNumber.copyWith(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: AppTextStyles.statLabel.copyWith(
                      color: _isHovered 
                          ? AppColors.textLight 
                          : Colors.white70,
                    ),
                    child: Text(widget.label),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DiagonalAccentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentRed.withAlpha(30)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.8, 0);
    path.lineTo(size.width * 0.4, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
