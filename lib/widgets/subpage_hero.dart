import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Reusable Hero section for subpages with Ken Burns effect
class SubPageHero extends StatefulWidget {
  final String title;
  final String tagline;
  final String imageUrl;

  const SubPageHero({
    super.key,
    required this.title,
    required this.tagline,
    required this.imageUrl,
  });

  @override
  State<SubPageHero> createState() => _SubPageHeroState();
}

class _SubPageHeroState extends State<SubPageHero> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Container(
      height: isMobile ? 500 : 550,
      width: double.infinity,
      color: AppColors.primaryNavy,
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.network(
                'https://t3.ftcdn.net/jpg/02/09/53/11/360_F_209531103_vK0N9zKq5Q0q5Q0q5Q0q5Q0q5Q0q5Q0q.jpg',
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          
          if (isMobile)
            _buildMobileLayout()
          else
            _buildDesktopLayout(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Side: Content
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 80, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // Tagline with vertical line
                Row(
                  children: [
                    Container(width: 40, height: 2, color: AppColors.accentRed),
                    const SizedBox(width: 12),
                    Text(
                      widget.tagline.toUpperCase(),
                      style: AppTextStyles.sectionLabel.copyWith(
                        letterSpacing: 4,
                        color: AppColors.accentRed,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Title
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Text(
                          widget.title,
                          style: AppTextStyles.heroTitle.copyWith(
                            fontSize: 64,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.accentRed,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right Side: Slanted Image
        Expanded(
          flex: 1,
          child: ClipPath(
            clipper: _SlantedClipper(),
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Stack(
      children: [
        // Image background with overlay
        Positioned.fill(
          child: Opacity(
            opacity: 0.4,
            child: Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryNavy.withAlpha(200),
                AppColors.primaryNavy,
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Text(
                  widget.tagline.toUpperCase(),
                  style: AppTextStyles.sectionLabel.copyWith(
                    letterSpacing: 4,
                    color: AppColors.accentRed,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: AppTextStyles.heroTitle.copyWith(
                    fontSize: 42,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Container(width: 60, height: 3, color: AppColors.accentRed),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SlantedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.15, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
