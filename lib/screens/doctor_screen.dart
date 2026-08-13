import 'package:flutter/material.dart';

import '../../core/city/person_health_service.dart';
import '../../core/models/character.dart';
import '../../core/models/character_portrait.dart';
import '../../data/game_data.dart';
import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_text_styles.dart';
import '../../ui/widgets/app_button.dart';
import '../../ui/widgets/app_card.dart';
import '../../ui/widgets/app_card_button.dart';
import '../../ui/widgets/game_scaffold.dart';
import '../../ui/widgets/game_status_bar.dart';
import '../../ui/widgets/status_item.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({
    super.key,
  });

  @override
  State<DoctorScreen> createState() =>
      _DoctorScreenState();
}

class _DoctorScreenState
    extends State<DoctorScreen> {
  @override
  Widget build(BuildContext context) {
    final caravan =
        game.player.caravan;

    final characters = <Character>[
      caravan.leader,
      ...caravan.companions,
    ];

    final healAllCost =
        CharacterHealthService
            .healAllCost(
      characters,
    );

    final canHealAny =
        CharacterHealthService
            .canHealAny(
      characters,
    );

    return GameScaffold(
      title: 'Doctor',
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
            characters.length + 1,
        itemBuilder: (
          context,
          index,
        ) {
          if (index == 0) {
return AppCardButton(
  text: canHealAny
      ? 'Heal All\n🪙${healAllCost.toStringAsFixed(0)}'
      : 'Full Health',
  onPressed: canHealAny &&
          caravan.gold >=
              healAllCost
      ? () {
          setState(() {
            caravan.gold -=
                healAllCost;

            CharacterHealthService
                .healAll(
              characters,
            );
          });
        }
      : null,
);
          }

          final character =
              characters[index - 1];

          final cost =
              CharacterHealthService
                  .healCost(
            character,
          );

          final canHeal =
              CharacterHealthService
                  .canHeal(
            character,
          );

          final healthPercent =
              character.maxHp <= 0
                  ? 0.0
                  : character.hp /
                      character.maxHp;

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
                  Column(
                    children: [
                      Container(
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
                        child:
                            CharacterPortrait(
                          seed: character
                              .id.hashCode,
                          dna:
                              character.portrait,
                          size: 80,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        character.name,
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
                            '${character.hp.toInt()} / ${character.maxHp.toInt()}',
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

                                    CharacterHealthService
                                        .heal(
                                      character,
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