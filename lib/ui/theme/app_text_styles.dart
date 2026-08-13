import 'package:flutter/material.dart';

class AppTextStyles {
  static const String headingFont =
      'Merriweather';

  static const String bodyFont =
      'Inter';

  static const TextStyle title =
      TextStyle(
        fontFamily: headingFont,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );

  static const TextStyle section =
      TextStyle(
        fontFamily: headingFont,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      );

  static const TextStyle body =
      TextStyle(
        fontFamily: bodyFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static const TextStyle caption =
      TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  static const TextStyle statIcon =
      TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  static const TextStyle statValue =
      TextStyle(
        fontFamily: bodyFont,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      );

  static const TextStyle display =
      TextStyle(
        fontFamily: headingFont,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      );
}

class StatText extends StatelessWidget {
  final String icon;
  final String value;

  const StatText({
    super.key,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style:
                AppTextStyles.statIcon,
          ),
          Text(
            value,
            textAlign:
                TextAlign.center,
            style:
                AppTextStyles.statValue,
          ),
        ],
      ),
    );
  }
}