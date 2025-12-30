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
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&q=80'), // Tech/Engineering background
          fit: BoxFit.cover,
          opacity: 0.15, // Slightly darker for better text contrast
        ), 
      ),
      child: Stack(
        children: [
          // Technical Grid Overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.network(
                'https://t3.ftcdn.net/jpg/02/09/53/11/360_F_209531103_vK0N9zKq5Q0q5Q0q5Q0q5Q0q5Q0q5Q0q.jpg', // Placeholder pattern since transparenttextures is failing
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.only(
              top: 120, 
              bottom: 80, 
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
                    const SizedBox(width: 60),
                    SizedBox(width: 450, child: _buildHeroForm(isMobile)),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accentRed.withOpacity(0.1),
            border: Border.all(color: AppColors.accentRed.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'FRANCHISE OPPORTUNITY',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accentRed,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Powering India’s\nElectric Future ⚡',
          style: AppTextStyles.heroTitle.copyWith(
            fontSize: isMobile ? 36 : 56,
            height: 1.1,
            color: Colors.white,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 24),
        Text(
          'FIXXEV Mobility Solutions is building a nationwide ecosystem for electric vehicle spare parts, servicing, and future-ready EV solutions.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.8),
            fontSize: 18,
            height: 1.6,
          ),
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            _HeroStat(navLabel: 'setup time', value: '4 WEEKS'),
            Container(height: 40, width: 1, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 24)),
            _HeroStat(navLabel: 'cost savings', value: '40%'),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroForm(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95), // Glass-morphism feel
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.business, color: AppColors.primaryNavy),
              ),
              const SizedBox(width: 12),
              Text(
                'Become an FIXXEV Partner',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 22, color: AppColors.primaryNavy),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Start your EV spare parts & service business today.',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _SimpleField(hint: 'Full Name', icon: Icons.person_outline),
          const SizedBox(height: 12), // Tighter spacing
          _SimpleField(hint: 'Phone Number', icon: Icons.phone_outlined),
          const SizedBox(height: 12),
          _SimpleField(hint: 'Email Address', icon: Icons.email_outlined),
          const SizedBox(height: 12),
          _SimpleField(hint: 'City / Location', icon: Icons.location_on_outlined),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'DOWNLOAD BROCHURE',
            onPressed: () {},
            width: double.infinity,
            icon: Icons.download_rounded,
            padding: const EdgeInsets.symmetric(vertical: 18), // Taller button
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
  final IconData icon;

  const _SimpleField({required this.hint, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
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
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
        ],
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1497366216548-37526070297c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1600&q=80'), // Professional corporate/tech office
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
          ),
          child: const Icon(Icons.play_arrow, color: AppColors.accentRed, size: 40),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          const SectionHeader(
            label: 'GENUINE SPARES',
            title: 'Complete Range of\nEV Spare Parts',
            isLight: true,
            centered: false,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          const SizedBox(height: 24),
          Text(
            'We stock and supply a wide range of EV components for smooth, reliable vehicle performance.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight.withOpacity(0.9),
              fontSize: 18,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _CheckListItem(text: 'Controllers & Chargers'),
              _CheckListItem(text: 'Motors & Motor Parts'),
              _CheckListItem(text: 'Lithium Batteries'),
              _CheckListItem(text: 'Sensors & Wiring Kits'),
              _CheckListItem(text: 'Tyres, Lights & Body Parts'),
            ],
          ),
      ],
    );
  }
}

class _CheckListItem extends StatelessWidget {
  final String text;
  const _CheckListItem({required this.text});

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
              const SectionHeader(title: 'Why Partner With FIXXEV?', label: 'ADVANTAGES', centered: true, isLight: true),
              const SizedBox(height: 80),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 600;
                  return Wrap(
                    spacing: 30,
                    runSpacing: 40,
                    alignment: WrapAlignment.center,
                    children: [
                      _BenefitCard(icon: Icons.trending_up, title: 'High ROI', desc: 'Lower capex means faster break-even point.', isMobile: isMobile),
                      _BenefitCard(icon: Icons.speed, title: 'Speed to Market', desc: 'Launch in 4 weeks vs 6 months for traditional.', isMobile: isMobile),
                      _BenefitCard(icon: Icons.headset_mic, title: 'Expert Support', desc: '24/7 technical assistance from HQ engineers.', isMobile: isMobile),
                      _BenefitCard(icon: Icons.build, title: 'OEM Parts', desc: 'Direct supply chain access for authentic spares.', isMobile: isMobile),
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
    return Container(
      color: AppColors.backgroundLight,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          const SectionHeader(title: 'Nationwide Network', label: 'EXPANSION', centered: true),
          const SizedBox(height: 60),
          SizedBox(
            height: 500,
            width: 1000,
            child: Stack(
              children: [
                const _GoogleMap(),
                // Pulsing Dots Overlay
                const _PulsingMapDot(top: 280, left: 360, label: 'Hyderabad (HQ)'),
                const _PulsingMapDot(top: 300, left: 380, label: 'Bangalore'),
                const _PulsingMapDot(top: 200, left: 350, label: 'Gurugram'),
                const _PulsingMapDot(top: 220, left: 450, label: 'Kolkata'),
                const _PulsingMapDot(top: 290, left: 400, label: 'Rajahmundry'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleMap extends StatelessWidget {
  const _GoogleMap();

  @override
  Widget build(BuildContext context) {
    // Register the iframe view factory
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'google-maps-embed',
      (int viewId) => html.IFrameElement()
        ..src = 'https://www.google.com/maps/embed?pb=!1m14!1m12!1m3!1d12082197.308827797!2d78.91756949306756!3d23.687872306691254!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!5e0!3m2!1sen!2sin!4v1767074470784!5m2!1sen!2sin'
        ..style.border = 'none'
        ..style.height = '100%'
        ..style.width = '100%'
        ..allowFullscreen = true,
    );

    return const HtmlElementView(viewType: 'google-maps-embed');
  }
}


// 5. Deployment Process
class _DeploymentProcessSection extends StatelessWidget {
  const _DeploymentProcessSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          const SectionHeader(title: '4 Steps to Launch', label: 'ROADMAP', centered: true),
          const SizedBox(height: 80),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 800) {
                 return Column(
                  children: const [
                    _ProcessStep(number: '01', title: 'Application', desc: 'Submit inquiry & site details'),
                    _ProcessStep(number: '02', title: 'Site Survey', desc: 'Remote & physical feasibility check'),
                    _ProcessStep(number: '03', title: 'Installation', desc: 'Container delivery & interior fit-out'),
                    _ProcessStep(number: '04', title: 'Grand Opening', desc: 'Marketing launch & operations start'),
                  ],
                 );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _ProcessStep(number: '01', title: 'Application', desc: 'Submit inquiry & site details'),
                  _ProcessStep(number: '02', title: 'Site Survey', desc: 'Remote & physical feasibility check'),
                  _ProcessStep(number: '03', title: 'Installation', desc: 'Container delivery & interior fit-out'),
                  _ProcessStep(number: '04', title: 'Grand Opening', desc: 'Marketing launch & operations start'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  final String number;
  final String title;
  final String desc;

  const _ProcessStep({required this.number, required this.title, required this.desc});

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
            children: const [
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

  const _PulsingMapDot({required this.top, required this.left, required this.label});

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
