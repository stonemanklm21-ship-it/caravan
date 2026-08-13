import 'package:flutter/material.dart';

import '../../core/economy/animal_market_service.dart';
import '../../core/models/animal.dart';
import '../../core/models/player_state.dart';
import '../../core/world/calendar_service.dart';
import '../../core/caravan/animal_service.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/app_button.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/game_scaffold.dart';
import '../../ui/widgets/game_status_bar.dart';
import '../../ui/widgets/status_item.dart';


class AnimalMarketScreen
    extends StatefulWidget {
  final PlayerState playerState;

  final AnimalMarketTier tier;

  const AnimalMarketScreen({
    super.key,
    required this.playerState,
    required this.tier,
  });

  @override
  State<AnimalMarketScreen>
      createState() =>
          _AnimalMarketScreenState();
}

class _AnimalMarketScreenState
    extends State<AnimalMarketScreen> {
  late List<Animal> stock;

  @override
  void initState() {
    super.initState();

    stock =
        AnimalMarketService
            .marketStock(
      city:
          widget.playerState.currentCity!,
      currentHour:
          widget.playerState
              .worldTimeHours
              .floor(),
      stockSize: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    final caravan =
        widget.playerState.caravan;

    return GameScaffold(
      title: 'Animal Market',
      statusBar: GameStatusBar(
        children: [
          StatusItem(
            icon: '🪙',
            value: caravan.gold
                .toStringAsFixed(0),
            color: AppColors.gold,
          ),
        ],
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: stock.length,
        itemBuilder:
            (context, index) {
          final animal =
              stock[index];

          final price =
              AnimalMarketService
                  .price(
            animal,
          );

          final canBuy =
              caravan.gold >=
                  price;

          return AppCard(
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  // Identity column
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration:
                            BoxDecoration(
                          border:
                              Border.all(
                            color:
                                AppColors
                                    .primary,
                            width: 1,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            6,
                          ),
                        ),
                        child: const Icon(
                          Icons.pets,
                          size: 40,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        animal.type.name,
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            AppTextStyles
                                .section,
                      ),
                    ],
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
 // Stats column
Expanded(
  child: Column(
    mainAxisAlignment:
        MainAxisAlignment.center,
    children: [
      Row(
        children: [
          Text(
            'Gender',
            style:
                AppTextStyles.caption,
          ),
          const Spacer(),
          Text(
            animal.gender.name ==
                    'male'
                ? 'Male'
                : 'Female',
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
            'Age',
            style:
                AppTextStyles.caption,
          ),
          const Spacer(),
          Text(
            CalendarService
                .formatAge(
              animal.ageYears,
            ),
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
            'Cargo Capacity',
            style:
                AppTextStyles.caption,
          ),
          const Spacer(),
Text(
  '${AnimalService.cargoCapacityKg(animal).toStringAsFixed(0)}kg',
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
            'Health',
            style:
                AppTextStyles.caption,
          ),
          const Spacer(),
          Text(
            '${animal.hp.toInt()}/${animal.type.maxHp.toInt()}',
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
                      child:
                          AppButton(
                        text:
                            'Buy\n🪙\n${price.toStringAsFixed(0)}',
                        onPressed:
                            canBuy
                                ? () {
                                    setState(
                                      () {
                                        caravan.gold -=
                                            price;

                                        caravan
                                            .animals
                                            .add(
                                              animal,
                                            );

                                        stock
                                            .removeAt(
                                          index,
                                        );
                                      },
                                    );
                                  }
                                : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}