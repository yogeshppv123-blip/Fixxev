import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../widgets/buttons/primary_button.dart';

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1593941707882-a5bba14938c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2000&q=80'), // Road/Nature theme
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.6), // Dark overlay
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: 100,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isMobile
                ? Column(
                    children: [
                      _buildFeaturesList(true),
                      const SizedBox(height: 60),
                      _buildContactForm(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: _buildFeaturesList(false),
                      ),
                      const SizedBox(width: 80),
                      Expanded(
                        flex: 4,
                        child: _buildContactForm(),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why Choose Us',
          style: AppTextStyles.sectionTitleLight.copyWith(
            fontSize: isMobile ? 32 : 44,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(width: 60, height: 4, color: AppColors.accentRed),
        const SizedBox(height: 32),
        Text(
          'At FIXXEV, we provide an ecosystem that ensures your electric vehicle remains in peak condition through skilled engineering and genuine support.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white.withOpacity(0.9),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 48),
        _buildFeatureItem(
          icon: Icons.shield_outlined,
          title: 'Commitment To Sustainability',
          description: 'Expanding high-quality EV support to accelerate green mobility.',
        ),
        const SizedBox(height: 32),
        _buildFeatureItem(
          icon: Icons.biotech_outlined,
          title: 'Advanced Diagnostics',
          description: 'Using next-gen tools to ensure precise and efficient repairs.',
        ),
        const SizedBox(height: 32),
        _buildFeatureItem(
          icon: Icons.handyman_outlined,
          title: 'Skilled Technician Support',
          description: 'Professionally trained experts dedicated to EV longevity.',
        ),
        const SizedBox(height: 32),
        _buildFeatureItem(
          icon: Icons.layers_outlined,
          title: 'Quality Controlled Spares',
          description: 'OEM-certified components for reliable and safe performance.',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.accentRed.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.accentRed, size: 28),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9), // Light green tint like reference
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Book Your Service',
            style: AppTextStyles.sectionTitle.copyWith(fontSize: 24, color: AppColors.primaryNavy),
          ),
          const SizedBox(height: 32),
          _buildField('Name'),
          const SizedBox(height: 16),
          _buildField('Email'),
          const SizedBox(height: 16),
          _buildField('Contact Number'),
          const SizedBox(height: 16),
          _buildField('Your Message', maxLines: 4),
          const SizedBox(height: 32),
          PrimaryButton(
            text: 'SEND REQUEST',
            onPressed: () {},
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

