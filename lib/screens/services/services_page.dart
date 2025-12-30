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
                  title: 'Professional EV Services',
                  tagline: 'Expert Care for Your EV',
                  imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&h=1440&q=80',
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
                            title: 'Why Choose EVJAZZ Services',
                            subtitle: 'Reliable, Affordable, and Professional',
                            centered: true,
                          ),
                          const SizedBox(height: 60),
                          Wrap(
                            spacing: 30,
                            runSpacing: 30,
                            alignment: WrapAlignment.center,
                            children: [
                              _BenefitItem(
                                icon: Icons.engineering,
                                title: 'Expert Technicians',
                                description: 'Our certified staff are trained to handle complex diagnostics and repairs for all EV types.',
                              ),
                              _BenefitItem(
                                icon: Icons.verified,
                                title: '100% Genuine Parts',
                                description: 'We use only authentic, high-quality spare parts to ensure longevity and safety.',
                              ),
                              _BenefitItem(
                                icon: Icons.settings_accessibility,
                                title: 'Standardized Process',
                                description: 'Every vehicle undergoes a rigorous 40-point check and standardized service protocol.',
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
