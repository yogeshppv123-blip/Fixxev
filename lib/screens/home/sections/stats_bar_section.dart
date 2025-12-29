import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../widgets/cards/cards.dart';

/// Stats bar section with animated counters
class StatsBarSection extends StatelessWidget {
  const StatsBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 60,
        vertical: isMobile ? 40 : 50,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: AppConstants.stats.map((stat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: StatCounterCard(
                    value: stat['value'] as int,
                    suffix: stat['suffix'] as String,
                    label: stat['label'] as String,
                  ),
                );
              }).toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: AppConstants.stats.map((stat) {
                return Expanded(
                  child: StatCounterCard(
                    value: stat['value'] as int,
                    suffix: stat['suffix'] as String,
                    label: stat['label'] as String,
                  ),
                );
              }).toList(),
            ),
    );
  }
}
