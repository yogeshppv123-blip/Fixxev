import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/section_header.dart';
import '../../widgets/buttons/primary_button.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

part 'ckd_dealership_sections.dart';

class CKDealershipScreen extends StatefulWidget {
  const CKDealershipScreen({super.key});

  @override
  State<CKDealershipScreen> createState() => _CKDealershipScreenState();
}

class _CKDealershipScreenState extends State<CKDealershipScreen> {
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // 1. Engineered Split Hero with Form
                const _DealershipHero(),

                // 2. Join Community (Image + Text) - NEW
                const _JoinCommunitySection(),

                // 3. Why Partner With Us (Dark Section)
                const _WhyPartnerSection(),

                // 4. The Container Advantage (Text + Image)
                const _ContainerAdvantageSection(),
                
                // 5. Low Risk, Scalable (Cards) - NEW
                const _ScalableGrowthSection(),

                // 6. Deployment Process
                const _DeploymentProcessSection(),

                // 7. Pan-India Network (Map)
                const _NetworkMapSection(),

                // 8. Model Showcase
                const _ModelShowcaseSection(),

                const FooterWidget(),
              ],
            ),
          ),
          
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomAppBar(
              isTransparent: !_isScrolled,
              backgroundColor: _isScrolled ? AppColors.navDark : null,
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
}

// 1. Engineered Split Hero
class _DealershipHero extends StatelessWidget {
  const _DealershipHero();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: size.height * 0.9),
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
      ),
      child: Stack(
        children: [
          // Background Image with Overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.network(
                'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryNavy.withAlpha(220),
                    AppColors.primaryNavy.withAlpha(150),
                    Colors.transparent,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.only(
              top: 140, 
              bottom: 100, 
              left: isMobile ? 24 : 80, 
              right: isMobile ? 24 : 80
            ),
            child: isMobile 
              ? Column(
                  children: [
                    _buildHeroText(isMobile),
                    const SizedBox(height: 50),
                    _buildHeroForm(isMobile),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _buildHeroText(isMobile)),
                    const SizedBox(width: 80),
                    SizedBox(width: 480, child: _buildHeroForm(isMobile)),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroText(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Powering the Future of EV\nInfrastructure with Smart,\nRapid Deployment Solutions.',
          style: AppTextStyles.heroTitle.copyWith(
            fontSize: isMobile ? 32 : 48,
            height: 1.2,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 24),
        Text(
          'Reimagine EV infrastructure with our modular CKD container model built for performance, speed, and scalability.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontSize: 18,
            height: 1.6,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildHeroForm(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Name', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
              Text('Phone', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _SimpleField(hint: 'Your Name', icon: null)),
              const SizedBox(width: 12),
              Expanded(child: _SimpleField(hint: 'Select', icon: Icons.keyboard_arrow_down)),
            ],
          ),
          const SizedBox(height: 20),
          Text('Email', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _SimpleField(hint: 'Your Email', icon: null),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Text('State', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold))),
              const SizedBox(width: 12),
              Expanded(child: Text('City', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _SimpleField(hint: 'Select State', icon: Icons.keyboard_arrow_down)),
              const SizedBox(width: 12),
              Expanded(child: _SimpleField(hint: 'Select City', icon: Icons.keyboard_arrow_down)),
            ],
          ),
          const SizedBox(height: 20),
          Text('Phone', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const _SimpleField(hint: '9880198801', icon: null),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'ENQUIRE NOW',
            onPressed: () {},
            width: double.infinity,
            backgroundColor: AppColors.primaryNavy,
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String navLabel;
  final String value;

  const _HeroStat({required this.navLabel, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.accentRed, fontSize: 28),
        ),
        Text(
          navLabel.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _SimpleField extends StatelessWidget {
  final String hint;
  final IconData? icon;

  const _SimpleField({required this.hint, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        suffixIcon: icon != null ? Icon(icon, color: AppColors.textGrey, size: 20) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}


// 2. The Container Advantage
class _ContainerAdvantageSection extends StatelessWidget {
  const _ContainerAdvantageSection();

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
                  _buildContent(),
                  const SizedBox(height: 40),
                  _buildImage(),
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
      height: 400,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: const _VideoPlayer(),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          RichText(
            text: TextSpan(
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 36, height: 1.2),
              children: [
                const TextSpan(text: 'CKD Containers '),
                TextSpan(
                  text: 'Smarter\nShowrooms, Built for\nPerformance.',
                  style: TextStyle(color: AppColors.primaryNavy),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Our CKD containers are designed for speed and efficiency, providing a complete showroom experience in a compact, modular format.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
          ),
          const SizedBox(height: 32),
          _FeaturePoint(text: 'Rapid deployment in under 4 weeks'),
          _FeaturePoint(text: 'High visibility and modern showroom design'),
          _FeaturePoint(text: 'Secure and durable construction'),
          _FeaturePoint(text: 'Easily relocatable and modular architecture'),
      ],
    );
  }
}

class _FeaturePoint extends StatelessWidget {
  final String text;
  const _FeaturePoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.accentRed, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class _CheckListItem extends StatelessWidget {
  final String text;
  const _CheckListItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(color: AppColors.accentRed, shape: BoxShape.circle),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}


// 3. Why Partner With Us (Dark Section)
class _WhyPartnerSection extends StatelessWidget {
  const _WhyPartnerSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryNavy,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const SectionHeader(
                title: 'Why Choose Fixx EV as Your Partner?',
                label: 'PARTNERSHIP BENEFITS',
                centered: true,
                isLight: true,
              ),
              const SizedBox(height: 80),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 600;
                  return Wrap(
                    spacing: 30,
                    runSpacing: 40,
                    alignment: WrapAlignment.center,
                    children: [
                      _BenefitCard(
                        icon: Icons.engineering,
                        title: 'Technical Support',
                        desc: 'Access to professionally trained technicians and experts.',
                        isMobile: isMobile,
                      ),
                      _BenefitCard(
                        icon: Icons.trending_up,
                        title: 'High ROI',
                        desc: 'Efficient business model with rapid break-even potential.',
                        isMobile: isMobile,
                      ),
                      _BenefitCard(
                        icon: Icons.local_shipping,
                        title: 'Supply Chain',
                        desc: 'Reliable access to OEM-certified spares and logistics.',
                        isMobile: isMobile,
                      ),
                      _BenefitCard(
                        icon: Icons.campaign,
                        title: 'Marketing Support',
                        desc: 'Growth through our centralized digital marketing tools.',
                        isMobile: isMobile,
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

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  final bool isMobile;

  const _BenefitCard({required this.icon, required this.title, required this.desc, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isMobile ? double.infinity : 260,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(icon, size: 32, color: AppColors.accentRed),
          ),
          const SizedBox(height: 24),
          Text(title, style: AppTextStyles.cardTitle.copyWith(color: Colors.white)),
          const SizedBox(height: 12),
          Text(desc, style: AppTextStyles.bodySmall.copyWith(color: Colors.white54), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}


// 4. Network Map
class _NetworkMapSection extends StatelessWidget {
  const _NetworkMapSection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      color: AppColors.backgroundLight,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile
              ? Column(
                  children: [
                    const SizedBox(height: 400, child: _GoogleMap()),
                    const SizedBox(height: 40),
                    _buildContent(isMobile),
                  ],
                )
              : Row(
                  children: [
                    const Expanded(child: SizedBox(height: 500, child: _GoogleMap())),
                    const SizedBox(width: 80),
                    Expanded(child: _buildContent(isMobile)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 36, height: 1.2),
            children: [
              const TextSpan(text: 'We are reaching every\n'),
              TextSpan(
                text: 'corner of India',
                style: const TextStyle(color: AppColors.primaryNavy),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Our mission is to make EV servicing accessible to everyone. We are rapidly expanding our network to ensure that no matter where you are, a Fixx EV authorized service centre is nearby.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey, height: 1.6),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 32),
        const _CheckPoint(text: 'Pan-India network of 500+ centres'),
        const _CheckPoint(text: 'Standardized service processes'),
        const _CheckPoint(text: 'Skilled technician support'),
        const _CheckPoint(text: 'OEM-approved spares access'),
      ],
    );
  }
}

class _CheckPoint extends StatelessWidget {
  final String text;
  const _CheckPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primaryNavy, size: 20),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _GoogleMap extends StatelessWidget {
  const _GoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    // Register the iframe view factory
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'google-maps-embed-fixx',
      (int viewId) => html.IFrameElement()
        ..src = 'https://www.google.com/maps/embed?pb=!1m14!1m12!1m3!1d12082197.308827797!2d78.91756949306756!3d23.687872306691254!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!5e0!3m2!1sen!2sin!4v1767074470784!5m2!1sen!2sin'
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..allowFullscreen = true,
    );

    return const HtmlElementView(viewType: 'google-maps-embed-fixx');
  }
}

class _VideoPlayer extends StatelessWidget {
  const _VideoPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    // Register the video element view factory
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'local-video-embed-fixx',
      (int viewId) {
        final videoElement = html.VideoElement()
          ..src = 'assets/dealership_video.mp4' // Local asset path
          ..style.border = 'none'
          ..style.height = '100%'
          ..style.width = '100%'
          ..style.objectFit = 'cover' // Ensure it fills the container
          ..autoplay = true
          ..loop = true
          ..muted = true; // Required for autoplay
        
        // Ensure play is called (sometimes needed for strict browser policies)
        videoElement.play();
        
        return videoElement;
      }
    );

    return const HtmlElementView(viewType: 'local-video-embed-fixx');
  }
}

// 5. Deployment Process
class _DeploymentProcessSection extends StatelessWidget {
  const _DeploymentProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryNavy,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Process of Dealership',
            label: 'ROADMAP',
            centered: true,
            isLight: true,
          ),
          const SizedBox(height: 80),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 800;
              if (isMobile) {
                return Column(
                  children: const [
                    _StepItem(number: '01', title: 'Submit Inquiry', desc: 'Fill the form to start your journey'),
                    SizedBox(height: 40),
                    _StepItem(number: '02', title: 'Site Selection', desc: 'Our experts help in finding the best spot'),
                    SizedBox(height: 40),
                    _StepItem(number: '03', title: 'Grand Launch', desc: 'Deployment and marketing support'),
                  ],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    const Expanded(child: _StepItem(number: '01', title: 'Submit Inquiry', desc: 'Fill the form to start your journey')),
                    const Icon(Icons.arrow_forward, color: Colors.white24, size: 40),
                    const Expanded(child: _StepItem(number: '02', title: 'Site Selection', desc: 'Our experts help in finding the best spot')),
                    const Icon(Icons.arrow_forward, color: Colors.white24, size: 40),
                    const Expanded(child: _StepItem(number: '03', title: 'Grand Launch', desc: 'Deployment and marketing support')),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String desc;

  const _StepItem({
    required this.number,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(number, style: AppTextStyles.heroTitle.copyWith(fontSize: 48, color: Colors.white12)),
        const SizedBox(height: 16),
        Text(title, style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 20)),
        const SizedBox(height: 8),
        Text(desc, style: AppTextStyles.bodySmall.copyWith(color: Colors.white70), textAlign: TextAlign.center),
      ],
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final String number;
  final String title;
  final String desc;

  const _ProcessStep({
    required this.number,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Text(number, style: AppTextStyles.heroTitle.copyWith(fontSize: 60, fontWeight: FontWeight.bold, color: AppColors.textGrey.withAlpha(25))),
          const SizedBox(height: 10),
          Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 8),
          Text(desc, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// 6. Model Showcase
class _ModelShowcaseSection extends StatelessWidget {
  const _ModelShowcaseSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          const SectionHeader(
            title: 'Choose Your Franchise Model',
            label: 'PARTNERSHIP MODELS',
            centered: true,
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _ModelCard(
                name: 'EV Spare Parts Micro-Outlet',
                type: 'MODEL 1',
                image: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Replace with store image
                features: ['Size: 200-300 sq. ft', 'Retail Focused', 'Low Investment', 'Ideal for High Footfall'],
              ),
              _ModelCard(
                name: 'Parts + Service Center',
                type: 'MODEL 2',
                image: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Workshop image
                features: ['Size: 500-800 sq. ft', 'Retail + Service', 'Diagnostic Bay', 'Higher ROI'],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final String name;
  final String type;
  final String image;
  final List<String> features;

  const _ModelCard({
    required this.name,
    required this.type,
    required this.image,
    this.features = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(image, height: 200, width: double.infinity, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentRed, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(name, style: AppTextStyles.cardTitle),
                const SizedBox(height: 16),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primaryNavy),
                      const SizedBox(width: 8),
                      Expanded(child: Text(feature, style: AppTextStyles.bodySmall.copyWith(fontSize: 13))),
                    ],
                  ),
                )).toList(),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'VIEW DETAILS',
                  onPressed: (){},
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingMapDot extends StatelessWidget {
  final double top;
  final double left;
  final String label;

  const _PulsingMapDot({
    required this.top,
    required this.left,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.accentRed.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 12, height: 12,
              decoration: const BoxDecoration(
                color: AppColors.accentRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label, 
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryNavy)
            ),
          ),
        ],
      ),
    );
  }
}
