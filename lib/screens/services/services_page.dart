import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../home/sections/services_section.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/subpage_hero.dart';
import '../../widgets/section_header.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
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
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Premium SubPage Hero
                const SubPageHero(
                  title: 'Our Services',
                  tagline: 'Engineering Excellence',
                  imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&h=1440&q=80',
                ),
                
                const ServicesSection(),
                
                // Why Our Engineering?
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
                  color: AppColors.backgroundLight,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        children: [
                          const SectionHeader(
                            title: 'The Fixxev Edge',
                            subtitle: 'Why our technical approach is different',
                            centered: true,
                          ),
                          const SizedBox(height: 60),
                          Wrap(
                            spacing: 30,
                            runSpacing: 30,
                            alignment: WrapAlignment.center,
                            children: [
                              _BenefitItem(
                                icon: Icons.analytics_outlined,
                                title: 'OEM Data Access',
                                description: 'We utilize proprietary manufacturer diagnostics tools that go beyond standard OBD readers.',
                              ),
                              _BenefitItem(
                                icon: Icons.high_quality,
                                title: 'Clean-Room Service',
                                description: 'Battery and motor repairs are performed in ISO-certified dust-free environments.',
                              ),
                              _BenefitItem(
                                icon: Icons.history,
                                title: 'Life-Cycle Support',
                                description: 'Detailed health reports and predictive maintenance scheduling for every component.',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
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

class _BenefitItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _BenefitItem({required this.title, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryNavy.withAlpha(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accentRed, size: 40),
          const SizedBox(height: 24),
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          Text(description, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
