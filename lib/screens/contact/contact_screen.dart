import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/floating_connect_buttons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/subpage_hero.dart';
import '../../widgets/section_header.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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
                  title: 'Contact Us',
                  tagline: 'Get In Touch',
                  imageUrl: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&h=1440&q=80',
                ),
                
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 100,
                    horizontal: MediaQuery.of(context).size.width < 768 ? 20 : 80,
                  ),
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        children: [
                          const SectionHeader(
                            title: 'Ready to Fix Your EV?',
                            subtitle: 'Visit our center or send us a message',
                            centered: true,
                          ),
                          const SizedBox(height: 80),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth < 900) {
                                return Column(
                                  children: [
                                    _buildContactInfoGrid(),
                                    const SizedBox(height: 60),
                                    _buildContactForm(),
                                  ],
                                );
                              }
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 2, child: _buildContactInfoGrid()),
                                  const SizedBox(width: 80),
                                  Expanded(flex: 3, child: _buildContactForm()),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Map Placeholder
                Container(
                  height: 400,
                  width: double.infinity,
                  color: AppColors.backgroundDark,
                  child: Stack(
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&q=80',
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation<double>(0.4),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on, color: AppColors.accentRed, size: 60),
                            const SizedBox(height: 20),
                            PrimaryButton(
                              text: 'OPEN IN GOOGLE MAPS',
                              onPressed: () {},
                              icon: Icons.map,
                            ),
                          ],
                        ),
                      ),
                    ],
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

  Widget _buildContactInfoGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContactInfoItem(
          icon: Icons.location_on,
          title: 'Visit Our HQ',
          detail: 'Plot No 24, IDA Nacharam, Hyderabad, Telangana - 500076',
        ),
        const SizedBox(height: 40),
        _ContactInfoItem(
          icon: Icons.phone_in_talk,
          title: 'Direct Support',
          detail: '+91 9848 123 456',
        ),
        const SizedBox(height: 40),
        _ContactInfoItem(
          icon: Icons.schedule,
          title: 'Working Hours',
          detail: 'Mon - Sat: 9:00 AM - 8:00 PM',
        ),
        const SizedBox(height: 40),
        _ContactInfoItem(
          icon: Icons.email_outlined,
          title: 'Email Inquiry',
          detail: 'info@evjazz.in',
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryNavy.withAlpha(50),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SEND A MESSAGE',
            style: AppTextStyles.sectionTitleLight.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 40),
          _CustomTextField(hint: 'Full Name'),
          const SizedBox(height: 24),
          _CustomTextField(hint: 'Email Address'),
          const SizedBox(height: 24),
          _CustomTextField(hint: 'Subject'),
          const SizedBox(height: 24),
          _CustomTextField(hint: 'Message', maxLines: 5),
          const SizedBox(height: 40),
          PrimaryButton(
            text: 'SUBMIT REQUEST',
            onPressed: () {},
            icon: Icons.send_rounded,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const _ContactInfoItem({required this.icon, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.accentRed.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.accentRed),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
            Text(detail, style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;

  const _CustomTextField({required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
        filled: true,
        fillColor: Colors.white.withAlpha(10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}


