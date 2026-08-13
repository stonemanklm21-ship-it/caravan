import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor:
              AppColors.primary,
          foregroundColor:
              AppColors.surface,
          side: const BorderSide(
            color: AppColors.gold,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style:
                AppTextStyles.body.copyWith(
              color:
                  AppColors.surface,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}