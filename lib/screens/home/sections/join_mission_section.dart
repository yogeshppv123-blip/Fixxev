import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';
import 'package:fixxev/widgets/buttons/primary_button.dart';
import 'package:go_router/go_router.dart';

class JoinMissionSection extends StatelessWidget {
  final Map<String, dynamic> content;
  const JoinMissionSection({super.key, required this.content});

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
        color: Colors.white,
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1531983412531-1f49a365ffed?auto=format&fit=crop&w=2000&q=80'),
          fit: BoxFit.cover,
          opacity: 0.08,
        ),
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Text(
                'JOIN THE MISSION',
                style: AppTextStyles.sectionLabel,
              ),
              const SizedBox(height: 16),
              Text(
                content['joinTitle'] ?? 'Join The Mission',
                textAlign: TextAlign.center,
                style: isMobile
                    ? AppTextStyles.sectionTitle.copyWith(fontSize: 32)
                    : AppTextStyles.sectionTitle.copyWith(fontSize: 48),
              ),
              const SizedBox(height: 32),
              Text(
                content['joinSubtitle'] ?? 'Partner with us to transform the EV spares & service landscape.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textGrey,
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
                          description: 'High-impact opportunity at the intersection of EV adoption growth and asset-light franchising.',
                        ),
                        const SizedBox(height: 24),
                        _buildOpportunityCard(
                          icon: Icons.handshake,
                          title: 'Franchisees',
                          description: 'Empowering entrepreneurs to become part of a trusted national brand with training and OEM parts.',
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildOpportunityCard(
                            icon: Icons.trending_up,
                            title: 'Strategic Investors',
                            description: 'A high-impact opportunity at the intersection of EV adoption growth and technology-enabled networks.',
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: _buildOpportunityCard(
                            icon: Icons.storefront,
                            title: 'Franchise Partners',
                            description: 'Empowering local entrepreneurs and existing workshops to become part of a trusted national brand.',
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 64),
              PrimaryButton(
                text: 'GET IN TOUCH TODAY',
                icon: Icons.mail_outline,
                onPressed: () {
                  context.go('/contact');
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
    return _HoverCard(icon: icon, title: title, description: description);
  }
}

class _HoverCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  
  const _HoverCard({required this.icon, required this.title, required this.description});
  
  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.primaryNavy : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _isHovered ? AppColors.primaryNavy : AppColors.textGrey.withAlpha(30)),
          boxShadow: _isHovered ? [
            BoxShadow(
              color: AppColors.primaryNavy.withAlpha(50),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ] : [],
        ),
        child: Column(
          children: [
            Icon(widget.icon, size: 48, color: _isHovered ? Colors.white : AppColors.secondary),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: AppTextStyles.cardTitle.copyWith(
                color: _isHovered ? Colors.white : AppColors.textDark,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: _isHovered ? Colors.white70 : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
