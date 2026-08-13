import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/app_colors.dart';

class StatusItem extends StatelessWidget {
  final String icon;
  final String value;
  final Color color;

  const StatusItem({
    super.key,
    required this.icon,
    required this.value,
    this.color = AppColors.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$icon $value',
      style:
          AppTextStyles.body.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}