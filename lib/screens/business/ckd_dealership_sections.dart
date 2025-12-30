part of 'ckd_dealership_screen.dart';

// 2. Join Community Section
class _JoinCommunitySection extends StatelessWidget {
  const _JoinCommunitySection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  children: [
                    _buildImage(),
                    const SizedBox(height: 40),
                    _buildContent(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildImage()),
                    const SizedBox(width: 80),
                    Expanded(child: _buildContent()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'), // EV/Green Energy Community
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SectionHeader(
          label: 'WHO WE ARE',
          title: 'India’s Fastest Growing\nEV Service Chain',
          centered: false,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        const SizedBox(height: 24),
        Text(
          'FIXXEV Mobility Solutions Private Limited is India’s fastest-growing EV spare parts and service store chain. We specialize in complete EV care—spare parts, diagnostics, repairs, and upcoming battery & retrofit solutions.',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Our Mission: To accelerate India’s EV adoption by making high-quality EV spare parts and professional servicing accessible across every city and town.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          text: 'APPLY FOR FRANCHISE',
          onPressed: () {},
          icon: Icons.arrow_forward_rounded,
        ),
      ],
    );
  }
}

// 5. Scalable Growth Section
class _ScalableGrowthSection extends StatelessWidget {
  const _ScalableGrowthSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionHeader(
                title: 'India’s EV Growth Story',
                label: 'MARKET OPPORTUNITY',
                centered: true,
              ),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: const [
                       _GrowthCard(
                        title: '20.8 Lakh Sales',
                        icon: Icons.trending_up,
                        bgImage: 'https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                        desc: 'Total EV sales in 2024',
                      ),
                      _GrowthCard(
                        title: '1 Crore by 2030',
                        icon: Icons.electric_car,
                        bgImage: 'https://images.unsplash.com/photo-1487887235947-a955ef187fcc?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                        isDark: true,
                        desc: 'Projected annual sales',
                      ),
                      _GrowthCard(
                        title: 'Tier 2 & 3 Growth',
                        icon: Icons.map,
                        bgImage: 'https://images.unsplash.com/photo-1518770660439-4636190af475?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80',
                        desc: 'Future market drivers',
                      ),
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
}

class _GrowthCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String bgImage;
  final String desc;
  final bool isDark;

  const _GrowthCard({
    required this.title,
    required this.icon,
    required this.bgImage,
    required this.desc,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(bgImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            isDark ? Colors.black.withOpacity(0.8) : AppColors.primaryNavy.withOpacity(0.85),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              desc,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
