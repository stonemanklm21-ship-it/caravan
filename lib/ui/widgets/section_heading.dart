import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class SectionHeading extends StatelessWidget {
  final String text;

  const SectionHeading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Text(
        text,
        style: AppTextStyles.section,
      ),
    );
  }
}