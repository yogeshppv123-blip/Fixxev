import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';

/// Testimonials section with premium animations and hover effects
class TestimonialsSection extends StatefulWidget {
  final Map<String, dynamic> content;
  const TestimonialsSection({super.key, required this.content});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    final testimonials = [
      {
        'name': 'Rahul Sharma',
        'role': 'Tesla Owner',
        'content': 'The AIOT diagnostics at FIXXEV saved me from a major battery failure. The real-time monitoring is mind-blowing!',
        'rating': 5,
      },
      {
        'name': 'Ananya Patel',
        'role': 'Nexon EV User',
        'content': 'Top-notch service! The technicians really know their way around electric vehicles. Highly recommended for EV owners.',
        'rating': 5,
      },
      {
        'name': 'Vikram Singh',
        'role': 'Fleet Manager',
        'content': 'We moved our entire EV fleet maintenance to FIXXEV. Their proactive support has increased our vehicle uptime by 40%.',
        'rating': 4,
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 100,
      ),
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
            isMobile
                ? Column(
                    children: testimonials.map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _AnimatedTestimonialCard(
                        name: t['name'] as String,
                        role: t['role'] as String,
                        content: t['content'] as String,
                        rating: t['rating'] as int,
                        delay: testimonials.indexOf(t) * 150,
                      ),
                    )).toList(),
                  )
                : Row(
                    children: testimonials.map((t) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: _AnimatedTestimonialCard(
                          name: t['name'] as String,
                          role: t['role'] as String,
                          content: t['content'] as String,
                          rating: t['rating'] as int,
                          delay: testimonials.indexOf(t) * 200,
                        ),
                      ),
                    )).toList(),
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
  final int delay;

  const _AnimatedTestimonialCard({
    required this.name,
    required this.role,
    required this.content,
    required this.rating,
    required this.delay,
  });

  @override
  State<_AnimatedTestimonialCard> createState() => _AnimatedTestimonialCardState();
}

class _AnimatedTestimonialCardState extends State<_AnimatedTestimonialCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.primaryNavy : AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered ? AppColors.accentRed : AppColors.textMuted.withAlpha(20),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered 
                      ? AppColors.accentRed.withAlpha(30) 
                      : Colors.black.withAlpha(5),
                  blurRadius: _isHovered ? 40 : 20,
                  offset: Offset(0, _isHovered ? 15 : 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quote icon
                Icon(
                  Icons.format_quote,
                  size: 40,
                  color: _isHovered ? AppColors.accentRed : AppColors.accentRed.withAlpha(50),
                ),
                const SizedBox(height: 16),
                // Rating
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
                // Feedback text
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _isHovered ? AppColors.textLight : AppColors.textDark,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                  child: Text('"${widget.content}"'),
                ),
                const SizedBox(height: 24),
                // Profile divider
                Container(
                  width: 40,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.accentRed,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                // User info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: AppTextStyles.cardTitle.copyWith(
                        fontSize: 16,
                        color: _isHovered ? AppColors.textLight : AppColors.textDark,
                      ),
                      child: Text(widget.name),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _isHovered ? AppColors.textGrey : AppColors.textMuted,
                      ),
                      child: Text(widget.role),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
