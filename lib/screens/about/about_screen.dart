import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../home/sections/about_us_section.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/subpage_hero.dart';
import '../../widgets/section_header.dart';

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
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Minimalist Hero for subpages
                // Premium SubPage Hero
                const SubPageHero(
                  title: 'Who We Are',
                  tagline: 'Driving the EV Revolution',
                  imageUrl: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&h=1440&q=80',
                ),
                
                const AboutUsSection(),
                
                // Our Mission & Vision
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
                  color: AppColors.backgroundLight,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        children: [
                          const SectionHeader(
                            title: 'Mission & Vision',
                            subtitle: 'Our commitment to the EV revolution',
                            centered: true,
                          ),
                          const SizedBox(height: 60),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth < 800) {
                                return Column(
                                  children: [
                                    _InfoCard(
                                      icon: Icons.rocket_launch,
                                      title: 'Our Mission',
                                      description: 'To accelerate India’s EV adoption by making high-quality EV spare parts and professional servicing accessible across every city and town.',
                                    ),
                                    const SizedBox(height: 30),
                                    _InfoCard(
                                      icon: Icons.visibility,
                                      title: 'Our Vision',
                                      description: 'To become the most trusted national partner for EV manufacturers and owners, ensuring zero downtime for every electric vehicle in India.',
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    child: _InfoCard(
                                      icon: Icons.rocket_launch,
                                      title: 'Our Mission',
                                      description: 'To accelerate India’s EV adoption by making high-quality EV spare parts and professional servicing accessible across every city and town.',
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    child: _InfoCard(
                                      icon: Icons.visibility,
                                      title: 'Our Vision',
                                      description: 'To become the most trusted national partner for EV manufacturers and owners, ensuring zero downtime for every electric vehicle in India.',
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Core Values
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        children: [
                          const SectionHeader(
                            title: 'Core Values',
                            subtitle: 'The principles that drive us forward',
                            centered: true,
                          ),
                          const SizedBox(height: 60),
                          Wrap(
                            spacing: 30,
                            runSpacing: 30,
                            alignment: WrapAlignment.center,
                            children: [
                              _ValueItem(
                                title: 'Precision',
                                description: 'Engineering-grade accuracy in every diagnostic and repair.',
                                icon: Icons.precision_manufacturing,
                              ),
                              _ValueItem(
                                title: 'Innovation',
                                description: 'Constantly evolving with the latest EV technologies.',
                                icon: Icons.lightbulb,
                              ),
                              _ValueItem(
                                title: 'Integrity',
                                description: 'Transparent services and honest communication with clients.',
                                icon: Icons.verified_user,
                              ),
                              _ValueItem(
                                title: 'Sustainability',
                                description: 'Every repair helps keep another EV on the road longer.',
                                icon: Icons.eco,
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accentRed.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accentRed, size: 32),
          ),
          const SizedBox(height: 24),
          Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 24)),
          const SizedBox(height: 16),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _ValueItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _ValueItem({required this.title, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy.withAlpha(5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryNavy.withAlpha(10)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryNavy, size: 40),
          const SizedBox(height: 20),
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
