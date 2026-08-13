import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 1,
      margin: const EdgeInsets.all(
        AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.xs,
        ),
        child: child,
      ),
    );
  }
}