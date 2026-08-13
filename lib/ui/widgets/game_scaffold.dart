import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class GameScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? statusBar;

  const GameScaffold({
    super.key,
    required this.title,
    required this.child,
    this.statusBar,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding =
        MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor:
          AppColors.background,
      body: Column(
        children: [
          // Notch / camera area
          Container(
            height: topPadding,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              image: DecorationImage(
                image: AssetImage(
                  'assets/ui/header_texture.png',
                ),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),

          // Top gold trim
          Container(
            height: 2,
            color: AppColors.gold,
          ),

          // Compact game header
          Container(
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              image: DecorationImage(
                image: AssetImage(
                  'assets/ui/header_texture.png',
                ),
                repeat: ImageRepeat.repeat,
              ),
            ),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              children: [
                if (Navigator.canPop(
                  context,
                )) ...[
                  IconButton(
                    onPressed: () =>
                        Navigator.pop(
                      context,
                    ),
                    padding:
                        EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 18,
                      color:
                          AppColors.gold,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],

                Expanded(
                  child: Text(
                    title,
                    overflow:
                        TextOverflow
                            .ellipsis,
                    style:
                        AppTextStyles.title
                            .copyWith(
                      color:
                          AppColors.gold,
                    ),
                  ),
                ),

                if (statusBar != null)
                  statusBar!,
              ],
            ),
          ),

          // Bottom gold trim
          Container(
            height: 2,
            color: AppColors.gold,
          ),

          // Textured brown separator
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              image: DecorationImage(
                image: AssetImage(
                  'assets/ui/header_texture.png',
                ),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),

Expanded(
  child: Container(
    decoration: const BoxDecoration(
      color: AppColors.background,
      image: DecorationImage(
        image: AssetImage(
          'assets/ui/header_texture.png',
        ),
        repeat: ImageRepeat.repeat,
        opacity: 0.8
      ),
    ),
    child: child,
  ),
),
        ],
      ),
    );
  }
}