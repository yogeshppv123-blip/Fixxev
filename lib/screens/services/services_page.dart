import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../home/sections/services_section.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/subpage_hero.dart';
import '../../widgets/section_header.dart';
import '../../widgets/buttons/primary_button.dart';

import 'package:fixxev/core/services/api_service.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _servicesFuture;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _servicesFuture = _apiService.getServices();
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
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: _servicesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final allServices = snapshot.data ?? [];
              final services = allServices.where((s) => s['status'] == 'Active').toList();

              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // 1. LIGHT HERO
                    _ServiceHeroLight(
                      title: 'Advanced Multi-Brand\nEV Solutions',
                      tagline: 'SERVICE EXCELLENCE',
                      imageUrl: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7',
                    ),

                    if (services.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(100),
                        child: Text('No services available at the moment.'),
                      )
                    else
                      ...List.generate(services.length, (index) {
                        final service = services[index];
                        return _ZigZagServiceBlock(
                          image: (service['image'] != null && service['image'].toString().isNotEmpty) 
                              ? service['image'] 
                              : _getServiceImage(index),
                          title: service['title'] ?? '',
                          label: '// ${service['category']?.toUpperCase() ?? 'SERVICE'}',
                          description: service['description'] ?? '',
                          items: const ['Professional Service', 'Certified Experts', 'Quality Parts'], // Placeholder features if not in DB
                          isReversed: index % 2 != 0,
                        );
                      }),

                    // 8. WHY CHOOSE FIXXEV
                    _WhyChooseServiceSection(),

                    // 9. CTA SECTION
                    _ServiceCTASection(),

                    const FooterWidget(),
                  ],
                ),
              );
            },
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              isTransparent: false,
              backgroundColor: AppColors.navDark,
              useLightText: true,
              onMenuPressed: () {},
              onContactPressed: () {},
            ),
          ),
          
          FloatingConnectButtons(scrollController: _scrollController),
        ],
      ),
    );
  }

  String _getServiceImage(int index) {
    final images = [
      'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d',
      'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158',
      'https://images.unsplash.com/photo-1497366216548-37526070297c',
      'https://images.unsplash.com/photo-1593941707882-a5bba14938c7',
      'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158',
      'https://images.unsplash.com/photo-1497366216548-37526070297c',
    ];
    return images[index % images.length];
  }
}


class _ZigZagServiceBlock extends StatelessWidget {
  final String image;
  final String title;
  final String label;
  final String description;
  final List<String> items;
  final bool isReversed;

  const _ZigZagServiceBlock({
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
      height: isMobile ? 300 : 500,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
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

class _ServiceHeroLight extends StatelessWidget {
  final String title;
  final String tagline;
  final String imageUrl;

  const _ServiceHeroLight({required this.title, required this.tagline, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Container(
      height: isMobile ? 500 : 550,
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
                      const SizedBox(height: 60),
                      Text(
                        tagline.toUpperCase(),
                        style: AppTextStyles.sectionLabel.copyWith(color: AppColors.accentRed, letterSpacing: 4),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: isMobile ? 36 : 56,
                          color: AppColors.primaryNavy,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(width: 80, height: 4, color: AppColors.accentRed),
                    ],
                  ),
                ),
              ),
              if (!isMobile)
                Expanded(
                  flex: 1,
                  child: ClipPath(
                    clipper: _SlantedClipper(),
                    child: Image.network(imageUrl, fit: BoxFit.cover, height: double.infinity),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SlantedClipper extends CustomClipper<Path> {
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
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _WhyChooseServiceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1497366216548-37526070297c'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Why Choose FIXXEV?',
                label: '// THE ADVANTAGE',
                isLight: true,
                centered: false,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 40,
                runSpacing: 40,
                children: [
                  _WhyPoint(text: 'Specialized for 2W, L3 and L5 Multi-brand electric vehicles.'),
                  _WhyPoint(text: 'High-end diagnostics for CAN Bus and LIN protocols.'),
                  _WhyPoint(text: 'ISO-certified workshops ensuring dust-free environments.'),
                  _WhyPoint(text: 'National network of 100+ stores for cross-city warranty support.'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WhyPoint extends StatelessWidget {
  final String text;
  const _WhyPoint({required this.text});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.accentRed, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withAlpha(200), fontSize: 18, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            'Optimize Your EV’s Performance\nWith Precision Engineering',
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.primaryNavy),
          ),
          const SizedBox(height: 48),
          PrimaryButton(
            text: 'BOOK AN APPOINTMENT',
            onPressed: () {},
            icon: Icons.calendar_month,
          ),
        ],
      ),
    );
  }
}
