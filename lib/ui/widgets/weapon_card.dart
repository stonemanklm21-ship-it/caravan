import 'package:flutter/material.dart';

import '../../core/models/weapon.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';
import 'app_card.dart';

class WeaponMarketCard extends StatelessWidget {
  final Weapon weapon;
  final double gold;
  final VoidCallback onBuy;

  const WeaponMarketCard({
    super.key,
    required this.weapon,
    required this.gold,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final canBuy =
        gold >= weapon.basePrice;

    return AppCard(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            // Identity column
            SizedBox(
              width: 90,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration:
                        BoxDecoration(
                      border:
                          Border.all(
                        color:
                            AppColors.primary,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        6,
                      ),
                    ),
                    child: const Icon(
                      Icons.sports_martial_arts,
                      size: 40,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    weapon.name,
                    textAlign:
                        TextAlign.center,
                    softWrap: true,
                    style:
                        AppTextStyles.section,
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            VerticalDivider(
              width: 1,
              thickness: 1,
              color:
                  AppColors.accent,
            ),

            const SizedBox(
              width: 8,
            ),

            // Stats column
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'Accuracy',
                        style:
                            AppTextStyles.caption,
                      ),
                      const Spacer(),
                      Text(
                        '+${weapon.accuracy}',
                        style:
                            AppTextStyles.statValue,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 2,
                  ),

                  Row(
                    children: [
                      Text(
                        'Damage',
                        style:
                            AppTextStyles.caption,
                      ),
                      const Spacer(),
                      Text(
                        'd${weapon.damageDie}',
                        style:
                            AppTextStyles.statValue,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Row(
                    children: [
                      Text(
                        'Weight',
                        style:
                            AppTextStyles.caption,
                      ),
                      const Spacer(),
                      Text(
                        '${weapon.weightKg.toStringAsFixed(1)}kg',
                        style:
                            AppTextStyles.statValue,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            // Action column
            SizedBox(
              width: 84,
              child: Opacity(
                opacity:
                    canBuy
                        ? 1.0
                        : 0.5,
                child: AppButton(
                  text:
                      'Buy\n🪙\n${weapon.basePrice.toStringAsFixed(0)}',
                  onPressed:
                      canBuy
                          ? onBuy
                          : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}