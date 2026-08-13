import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppCardButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;

  const AppCardButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 72,
  });

  @override
  Widget build(BuildContext context) {
    final enabled =
        onPressed != null;

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Material(
        color: AppColors.primary,
        borderRadius:
            BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius:
              BorderRadius.circular(16),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
              border:
                  const BorderSide(
                color: AppColors.gold,
                width: 1,
              ).toBorder(),
            ),
            child: Center(
              child: Text(
                text,
                textAlign:
                    TextAlign.center,
                style:
                    AppTextStyles.body
                        .copyWith(
                  color:
                      AppColors.surface,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on BorderSide {
  Border toBorder() {
    return Border.fromBorderSide(
      this,
    );
  }
}