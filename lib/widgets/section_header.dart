import 'package:flutter/material.dart';
import 'package:fixxev/core/theme/app_colors.dart';
import 'package:fixxev/core/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String? label;
  final String title;
  final String? subtitle;
  final bool isLight;
  final bool centered;
  final CrossAxisAlignment crossAxisAlignment;

  const SectionHeader({
    super.key,
    this.label,
    required this.title,
    this.subtitle,
    this.isLight = false,
    this.centered = true,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centered ? CrossAxisAlignment.center : crossAxisAlignment,
      children: [
        if (label != null) ...[
          Text(
            label!.toUpperCase(),
            style: AppTextStyles.sectionLabel,
          ),
          const SizedBox(height: 12),
        ],
        Text(
          title,
          style: (isLight ? AppTextStyles.sectionTitleLight : AppTextStyles.sectionTitle).copyWith(
            fontSize: MediaQuery.of(context).size.width < 768 ? 26 : 36,
          ),
          textAlign: centered ? TextAlign.center : TextAlign.left,
        ),
        const SizedBox(height: 16),
        // The signature accent line
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.accentRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 20),
          Text(
            subtitle!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isLight ? AppColors.textGrey : AppColors.textDark.withAlpha(180),
              fontSize: 16,
            ),
            textAlign: centered ? TextAlign.center : TextAlign.left,
          ),
        ],
      ],
    );
  }
}
