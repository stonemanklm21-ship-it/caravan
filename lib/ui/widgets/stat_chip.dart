import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class StatChip extends StatelessWidget {
  final String label;
  final String value;

  const StatChip({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary,
          width: 1,
        ),
      ),
      child: Text(
        '$label $value',
        style: AppTextStyles.caption,
      ),
    );
  }
}