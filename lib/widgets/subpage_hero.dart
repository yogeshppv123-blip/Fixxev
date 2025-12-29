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
    return Container(
      height: 450,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
      ),
      child: Stack(
        children: [
          // Ken Burns Image Effect
          AnimatedBuilder(
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
          // Gradient Overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryNavy.withAlpha(180),
                  AppColors.primaryNavy.withAlpha(220),
                ],
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                // Tagline with vertical line
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 30, height: 2, color: AppColors.accentRed),
                    const SizedBox(width: 12),
                    Text(
                      widget.tagline.toUpperCase(),
                      style: AppTextStyles.sectionLabel.copyWith(
                        letterSpacing: 4,
                        color: AppColors.accentRed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 30, height: 2, color: AppColors.accentRed),
                  ],
                ),
                const SizedBox(height: 20),
                // Title
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Text(
                          widget.title,
                          style: AppTextStyles.heroTitle.copyWith(
                            fontSize: 56,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
