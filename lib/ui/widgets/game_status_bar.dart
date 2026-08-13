import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class GameStatusBar
    extends StatelessWidget {
  final List<Widget> children;

  const GameStatusBar({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 4,
        children: children,
      ),
    );
  }
}