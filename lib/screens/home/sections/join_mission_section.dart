import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';

class JoinMissionSection extends StatelessWidget {
  const JoinMissionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 100,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryNavy,
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1531983412531-1f49a365ffed?auto=format&fit=crop&w=2000&q=80'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Text(
                'JOIN THE MISSION',
                style: AppTextStyles.sectionLabel.copyWith(color: AppColors.accentRed),
              ),
              const SizedBox(height: 16),
              Text(
                'DRIVING INDIA’S EV FUTURE',
                textAlign: TextAlign.center,
                style: isMobile
                    ? AppTextStyles.sectionTitleLight.copyWith(fontSize: 32)
                    : AppTextStyles.sectionTitleLight.copyWith(fontSize: 48),
              ),
              const SizedBox(height: 32),
              Text(
                'If you are an investor, partner, or entrepreneur who believes in the future of clean mobility, you are most welcome to join this mission and grow with us.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textLight.withAlpha(200),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 56),
              isMobile
                  ? Column(
                      children: [
                        _buildOpportunityCard(
                          icon: Icons.trending_up,
                          title: 'Strategic Investors',
                          description: 'High-impact opportunity at the intersection of EV adoption and asset-light franchising.',
                        ),
                        const SizedBox(height: 24),
                        _buildOpportunityCard(
                          icon: Icons.handshake,
                          title: 'Channel Partners',
                          description: 'Join India’s largest EV service ecosystem with standardized processes and OEM parts.',
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildOpportunityCard(
                            icon: Icons.trending_up,
                            title: 'Strategic Investors',
                            description: 'High-impact opportunity at the intersection of EV adoption growth and asset-light franchising.',
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: _buildOpportunityCard(
                            icon: Icons.handshake,
                            title: 'Channel Partners',
                            description: 'Join India’s largest EV service ecosystem with standardized processes and OEM parts.',
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 64),
              PrimaryButton(
                text: 'GET IN TOUCH TODAY',
                icon: Icons.mail_outline,
                onPressed: () {
                  // Navigate to contact
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpportunityCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(15)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.accentRed),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppTextStyles.cardTitle.copyWith(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}
