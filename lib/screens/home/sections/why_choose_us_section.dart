import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../widgets/cards/cards.dart';
import '../../../widgets/buttons/primary_button.dart';

/// Why Choose Us section with features list and contact form
class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'lightbulb':
        return Icons.lightbulb;
      case 'speed':
        return Icons.speed;
      case 'verified':
        return Icons.verified;
      case 'eco':
        return Icons.eco;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.primaryGreen.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            right: -100,
            top: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textLight.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            left: -50,
            bottom: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentGold.withOpacity(0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 60,
              vertical: 80,
            ),
            child: isMobile
                ? _buildMobileLayout()
                : _buildDesktopLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Features
        Expanded(
          flex: 5,
          child: _buildFeaturesList(),
        ),
        const SizedBox(width: 60),
        // Right side - Contact Form
        Expanded(
          flex: 4,
          child: _buildContactForm(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildFeaturesList(),
        const SizedBox(height: 60),
        _buildContactForm(),
      ],
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why Choose',
          style: AppTextStyles.sectionTitleLight.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          'FIXXEV?',
          style: AppTextStyles.sectionTitleLight.copyWith(
            fontSize: 44,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'FIXXEV stands out as a pioneer in delivering seamless, tech-driven solutions for all your EV needs.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 32),
        // Features list
        ...AppConstants.whyChooseUs.map((item) {
          return FeatureCard(
            icon: _getIconData(item['icon']!),
            title: item['title']!,
            description: item['description']!,
          );
        }),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.lightMint,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book Your Service',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            'Get in touch with our experts',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 32),
          // Form fields
          _buildTextField(
            hint: 'Your Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            hint: 'Email Address',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            hint: 'Phone Number',
            icon: Icons.phone_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            hint: 'Your Message',
            icon: Icons.message_outlined,
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Submit Request',
            icon: Icons.send,
            width: double.infinity,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: maxLines == 1
            ? Icon(icon, color: AppColors.primaryGreen)
            : null,
        alignLabelWithHint: true,
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
      ),
    );
  }
}
