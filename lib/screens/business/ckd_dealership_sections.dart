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
        RichText(
          text: TextSpan(
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 40, height: 1.2),
            children: [
              const TextSpan(text: 'Join the Fixx EV\nCommunity '),
              TextSpan(
                text: 'Get Your CKD\nContainer!',
                style: TextStyle(color: AppColors.primaryNavy),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Join our growing network of entrepreneurs. Our modular CKD container model is designed for rapid deployment, allowing you to start your EV service business in record time.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
        ),
        const SizedBox(height: 16),
        Text(
          'Our containers are built to last, providing a professional and efficient workspace for your technicians and an inviting showroom for your customers.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
        ),
        const SizedBox(height: 32),
        PrimaryButton(
          text: 'LEARN MORE',
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
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 36, height: 1.2),
                  children: [
                    const TextSpan(text: "It's low-risk, scalable, "),
                    TextSpan(
                      text: 'and\nfuture-ready.',
                      style: TextStyle(color: AppColors.primaryNavy),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              isMobile
                  ? Column(
                      children: [
                        _buildImage(),
                        const SizedBox(height: 40),
                        _buildCards(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildImage()),
                        const SizedBox(width: 60),
                        Expanded(child: _buildCards()),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1531482615713-2afd69097998?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCards() {
    return Column(
      children: [
        _GrowthInfoCard(
          title: 'Lower Risk, Better Results',
          description: 'Our model minimizes initial overhead while maximizing operational efficiency.',
          color: AppColors.primaryNavy,
        ),
        const SizedBox(height: 16),
        _GrowthInfoCard(
          title: 'High-Impact, Asset-light',
          description: 'Focus on growth without the burden of excessive physical assets.',
          color: Colors.black,
        ),
        const SizedBox(height: 16),
        _GrowthInfoCard(
          title: 'Technically Advanced Tools',
          description: 'Benefit from state-of-the-art diagnostics and management software.',
          color: AppColors.primaryNavy,
        ),
      ],
    );
  }
}

class _GrowthInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const _GrowthInfoCard({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
          ),
        ],
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
