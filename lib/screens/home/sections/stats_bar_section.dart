import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Stats bar section with animated counters
class StatsBarSection extends StatelessWidget {
  const StatsBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    const stats = [
      {'value': '5000+', 'label': 'Happy Customers'},
      {'value': '100%', 'label': 'Genuine Spares'},
      {'value': '2W/L3/L5', 'label': 'Vehicle Support'},
      {'value': 'PAN India', 'label': 'Service Network'},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 40 : 60,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy, // Darker theme like EVJAZZ stats
      ),
      child: isMobile
          ? Column(
              children: stats.map((stat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: _StatItem(
                    value: stat['value']!,
                    label: stat['label']!,
                  ),
                );
              }).toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stats.map((stat) {
                return _StatItem(
                  value: stat['value']!,
                  label: stat['label']!,
                );
              }).toList(),
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.heroTitle.copyWith(
            color: AppColors.accentRed,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
