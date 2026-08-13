import 'package:flutter/material.dart';

import '../core/city/animal_health_service.dart';
import '../core/models/animal.dart';
import '../core/models/player_state.dart';
import '../core/world/calendar_service.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';
import '../ui/widgets/app_button.dart';
import '../ui/widgets/app_card.dart';
import '../ui/widgets/app_card_button.dart';
import '../ui/widgets/game_scaffold.dart';
import '../ui/widgets/game_status_bar.dart';
import '../ui/widgets/status_item.dart';

class VetScreen extends StatefulWidget {
  final PlayerState playerState;

  const VetScreen({
    super.key,
    required this.playerState,
  });

  @override
  State<VetScreen> createState() =>
      _VetScreenState();
}

class _VetScreenState
    extends State<VetScreen> {
  @override
  Widget build(BuildContext context) {
    final caravan =
        widget.playerState.caravan;

    final animals =
        caravan.animals;

    final hasAnimals =
        animals.isNotEmpty;

    final healAllCost =
        AnimalHealthService
            .healAllCost(
      animals,
    );

    final needsHealing =
        AnimalHealthService
            .canHealAny(
      animals,
    );

    return GameScaffold(
      title: 'Vet',
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
        itemCount:
            animals.length + 1,
        itemBuilder: (
          context,
          index,
        ) {
          if (index == 0) {
            return AppCardButton(
              text: !hasAnimals
                  ? 'No Animals'
                  : needsHealing
                      ? 'Heal All\n🪙${healAllCost.toStringAsFixed(0)}'
                      : 'Full Health',
              onPressed: hasAnimals &&
                      needsHealing &&
                      caravan.gold >=
                          healAllCost
                  ? () {
                      setState(
                        () {
                          caravan.gold -=
                              healAllCost;

                          AnimalHealthService
                              .healAll(
                            animals,
                          );
                        },
                      );
                    }
                  : null,
            );
          }

          final animal =
              animals[index - 1];

          final cost =
              AnimalHealthService
                  .healCost(
            animal,
          );

          final canHeal =
              AnimalHealthService
                  .canHeal(
            animal,
          );

          final healthPercent =
              animal.type.maxHp <= 0
                  ? 0.0
                  : animal.hp /
                      animal
                          .type
                          .maxHp;

          final healthColor =
              healthPercent >= 0.67
                  ? Colors.green
                  : healthPercent >= 0.33
                      ? Colors.orange
                      : Colors.red;

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

                      Text(
                        CalendarService
                            .formatAge(
                          animal
                              .ageYears,
                        ),
                        style:
                            AppTextStyles
                                .caption,
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

                  // Health column
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          const Text(
                            'Health',
                            style:
                                TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          LinearProgressIndicator(
                            value:
                                healthPercent,
                            minHeight:
                                12,
                            borderRadius:
                                BorderRadius.circular(
                              8,
                            ),
                            valueColor:
                                AlwaysStoppedAnimation<
                                    Color>(
                              healthColor,
                            ),
                            backgroundColor:
                                Colors.black12,
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Text(
                            '${animal.hp.toInt()} / ${animal.type.maxHp.toInt()}',
                            style:
                                const TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ],
                      ),
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
                          canHeal
                              ? 1.0
                              : 0.5,
                      child:
                          AppButton(
                        text: canHeal
                            ? 'Heal\n🪙${cost.toStringAsFixed(0)}'
                            : 'Full\nHealth',
                        onPressed: canHeal &&
                                caravan.gold >=
                                    cost
                            ? () {
                                setState(
                                  () {
                                    caravan.gold -=
                                        cost;

                                    AnimalHealthService
                                        .heal(
                                      animal,
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