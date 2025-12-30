import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 1. LIGHT HERO (Matching Reference Layout)
                _AboutHeroLight(
                  title: 'Powering The Future\nOf Electric Mobility',
                  tagline: 'ABOUT US',
                  description1: 'At **FIXXEV**, we are committed to revolutionizing the electric vehicle (EV) service industry by offering **multi-brand servicing, repairs, refurbishment, and warranty management**. With a combined experience of over **20+ years**, our team of skilled professionals and EV experts ensures that every vehicle receives top-notch care, enhancing its efficiency and longevity.',
                  description2: 'As the demand for sustainable mobility grows, **FIXXEV** stands at the forefront of **after-sales service, fleet management, and component-level repairs**, ensuring that EV owners and businesses have access to reliable and cost-effective solutions.',
                  imageUrl: 'https://images.unsplash.com/photo-1581092160562-40aa08e78837', // Bike Mechanic
                ),

                // 2. STATS BAR (Our Theme: Navy)
                _AboutStatsBar(),

                // 3. CORE VALUES (Text Left)
                _AboutZigZagBlock(
                  image: 'https://images.unsplash.com/photo-1617469767053-d3b508a0d84e?q=80&w=1200', // Car Mechanic Work
                  title: 'Our Core Values',
                  label: '// VALUES',
                  description: 'At **FIXXEV**, we are driven by integrity, excellence, and a deep commitment to the environment. Our values guide every diagnostic we run and every part we replace.',
                  items: ['Integrity in every service', 'Excellence in engineering', 'Sustainable EV solutions'],
                  isReversed: false,
                ),

                // 4. CSR (Text Right)
                _AboutZigZagBlock(
                  image: 'https://images.unsplash.com/photo-1531983412531-1f49a365ffed', // Solar/Eco
                  title: 'Corporate Social Responsibility (CSR)',
                  label: '// GIVING BACK',
                  description: 'FIXXEV is committed to making a positive impact on the environment and society. Our initiatives focus on **reducing carbon footprints** and promoting clean energy adoption through free community awareness programs.',
                  items: ['Green recycling programs', 'Community EV awareness', 'Waste reduction protocols'],
                  isReversed: true,
                ),

                // 5. OUR GOAL (Text Left)
                _AboutZigZagBlock(
                  image: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7', // Battery Lab
                  title: 'Our Goal',
                  label: '// VISION',
                  description: 'Our goal is to build India\'s most reliable **EV support ecosystem**, ensuring that every electric vehicle on the road has access to high-precision engineering and authentic spare parts.',
                  items: ['Zero downtime for EV users', 'Nationwide service availability', 'Affordable premium care'],
                  isReversed: false,
                ),

                // 6. EXPANSION (Text Right)
                _AboutZigZagBlock(
                  image: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e', // Diagnostics
                  title: 'Future Plans & Expansion',
                  label: '// THE FUTURE',
                  description: 'We are rapidly expanding our footprint across India. With upcoming **battery tech centers** and retrofit solutions, FIXXEV is poised to lead the EV after-market revolution.',
                  items: ['Upcoming battery tech centers', 'Expansion to 200+ cities', 'Next-gen retrofit solutions'],
                  isReversed: true,
                ),

                // 7. JOIN US CTA
                _AboutCTASection(),

                const FooterWidget(),
              ],
            ),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              isTransparent: false,
              onMenuPressed: () {},
              onContactPressed: () {},
            ),
          ),
          
          FloatingConnectButtons(scrollController: _scrollController),
        ],
      ),
    );
  }
}

class _AboutHeroLight extends StatelessWidget {
  final String title;
  final String tagline;
  final String description1;
  final String description2;
  final String imageUrl;

  const _AboutHeroLight({
    required this.title,
    required this.tagline,
    required this.description1,
    required this.description2,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: EdgeInsets.only(top: isMobile ? 80 : 120, bottom: 60),
      width: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: isMobile ? 24 : 80, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        tagline.toUpperCase(),
                        style: AppTextStyles.sectionLabel.copyWith(
                          color: Colors.green.shade700, // Using reference style for label
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: isMobile ? 36 : 48,
                          color: AppColors.primaryNavy,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(width: 60, height: 4, color: AppColors.accentRed), // Red line for our theme
                      const SizedBox(height: 32),
                      _buildRichText(description1),
                      const SizedBox(height: 20),
                      _buildRichText(description2),
                    ],
                  ),
                ),
              ),
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: ClipPath(
                    clipper: _AboutHeroClipper(),
                    child: Container(
                      height: 550,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(String text) {
    List<TextSpan> spans = [];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 1) {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ));
      } else {
        spans.add(TextSpan(text: parts[i]));
      }
    }
    return RichText(
      text: TextSpan(
        style: AppTextStyles.bodySmall.copyWith(
          color: Colors.black54,
          height: 1.6,
          fontSize: 14,
        ),
        children: spans,
      ),
    );
  }
}

class _AboutHeroClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _AboutStatsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      color: AppColors.primaryNavy, // Back to Navy theme
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  children: [
                    _StatItem(value: 5000, suffix: '+', label: 'Satisfied Customers'),
                    const SizedBox(height: 40),
                    _StatItem(value: 90, suffix: '%', label: 'Problem Resolution Rate'),
                    const SizedBox(height: 40),
                    _StatItem(value: 100, suffix: '%', label: 'Commitment to Sustainability'),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(value: 5000, suffix: '+', label: 'Satisfied Customers'),
                    _StatItem(value: 90, suffix: '%', label: 'Problem Resolution Rate'),
                    _StatItem(value: 100, suffix: '%', label: 'Commitment to Sustainability'),
                  ],
                ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String suffix;
  final String label;
  const _StatItem({required this.value, required this.suffix, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value.toDouble()),
          duration: const Duration(seconds: 2),
          curve: Curves.easeOutExpo,
          builder: (context, val, child) {
            return Text(
              '${val.toInt()}$suffix',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.accentRed, // Red numbers for our theme
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.sectionLabel.copyWith(color: Colors.white.withAlpha(180), fontSize: 13, letterSpacing: 2),
        ),
      ],
    );
  }
}

class _AboutZigZagBlock extends StatelessWidget {
  final String image;
  final String title;
  final String label;
  final String description;
  final List<String> items;
  final bool isReversed;

  const _AboutZigZagBlock({
    required this.image,
    required this.title,
    required this.label,
    required this.description,
    required this.items,
    required this.isReversed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    final imageWidget = Container(
      height: isMobile ? 300 : 450,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
    );

    final contentWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyles.sectionLabel.copyWith(color: AppColors.accentRed, letterSpacing: 2),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: isMobile ? 28 : 36,
            color: AppColors.primaryNavy,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 40, height: 3, color: AppColors.accentRed),
        const SizedBox(height: 24),
        _buildRichText(description),
        const SizedBox(height: 32),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.accentRed, size: 20),
              const SizedBox(width: 12),
              Text(item, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        )),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isMobile ? 20 : 80,
      ),
      color: isReversed ? Colors.white : AppColors.backgroundLight.withAlpha(50),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  children: [
                    imageWidget,
                    const SizedBox(height: 40),
                    contentWidget,
                  ],
                )
              : Row(
                  children: [
                    if (!isReversed) Expanded(child: imageWidget),
                    if (!isReversed) const SizedBox(width: 80),
                    Expanded(child: contentWidget),
                    if (isReversed) const SizedBox(width: 80),
                    if (isReversed) Expanded(child: imageWidget),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildRichText(String text) {
    List<TextSpan> spans = [];
    final parts = text.split('**');
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 1) {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryNavy),
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
}

class _AboutCTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      color: AppColors.backgroundLight.withAlpha(30),
      child: Column(
        children: [
          Text(
            'Join Us In Driving The EV Revolution!',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.primaryNavy),
          ),
          const SizedBox(height: 16),
          Text(
            'At FIXXEV, we are always looking for passionate partners and talented individuals.\nLet\'s power the future together.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
          ),
          const SizedBox(height: 48),
          PrimaryButton(
            text: 'CONTACT US',
            onPressed: () {},
            icon: Icons.mail_outline,
          ),
        ],
      ),
    );
  }
}
