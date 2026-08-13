import 'package:flutter/material.dart';

import '../core/caravan/skill_service.dart';
import '../core/city/recruitment_service.dart';
import '../core/models/character_portrait.dart';
import '../core/models/player_state.dart';
import '../core/models/recruit.dart';
import '../core/models/skill.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';
import '../ui/widgets/app_button.dart';
import '../ui/widgets/app_card.dart';
import '../ui/widgets/game_scaffold.dart';
import '../ui/widgets/game_status_bar.dart';
import '../ui/widgets/status_item.dart';

class RecruitmentScreen extends StatefulWidget {
  final PlayerState playerState;

  const RecruitmentScreen({
    super.key,
    required this.playerState,
  });

  @override
  State<RecruitmentScreen> createState() =>
      _RecruitmentScreenState();
}

class _RecruitmentScreenState
    extends State<RecruitmentScreen> {
  late List<Recruit> recruits;

  @override
  void initState() {
    super.initState();

    recruits =
        RecruitmentService.marketStock(
      city:
          widget.playerState.currentCity!,
      tier:
          RecruitmentMarketTier.basic,
      currentHour: widget
          .playerState.worldTimeHours
          .floor(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: 'Recruitment Hall',
      statusBar: GameStatusBar(
        children: [
          StatusItem(
            icon: '🪙',
            value: widget
                .playerState
                .caravan
                .gold
                .toStringAsFixed(0),
            color: AppColors.gold,
          ),
        ],
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: recruits.length,
        itemBuilder: (context, index) {
          final recruit =
              recruits[index];

          final character =
              recruit.character;

          final canHire = widget
                  .playerState
                  .caravan
                  .gold >=
              recruit.hiringCost;

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
                          dna: character
                              .portrait,
                          size: 80,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        '${character.name} (${character.ageYears})',
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            AppTextStyles
                                .section,
                      ),

                      Text(
                        '🪙${character.wagePerDay.toInt()}/day',
                        textAlign:
                            TextAlign
                                .center,
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

                  // Stats column
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Text(
                          'Stats',
                          style: AppTextStyles
                              .body
                              .copyWith(
                            color:
                                AppColors
                                    .primary,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Row(
                          children: [
                            StatText(
                              icon: '❤️',
                              value:
                                  '${character.maxHp.toInt()}',
                            ),
                            StatText(
                              icon: '🏃',
                              value: character
                                  .speed
                                  .toStringAsFixed(
                                    1,
                                  ),
                            ),
                            StatText(
                              icon: '🎒',
                              value: character
                                  .cargoCapacityKg
                                  .toStringAsFixed(
                                    0,
                                  ),
                            ),
                            StatText(
                              icon: '🍖',
                              value:
                                  '${(character.caloriesPerDay / 1000).toStringAsFixed(1)}k',
                            ),
                            StatText(
                              icon: '💧',
                              value: character
                                  .waterPerDay
                                  .toStringAsFixed(
                                    1,
                                  ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 8,
                        ),

                        Text(
                          'Skills',
                          style: AppTextStyles
                              .body
                              .copyWith(
                            color:
                                AppColors
                                    .primary,
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Row(
                          children: [
                            StatText(
                              icon: '🩺',
                              value:
                                  '${SkillService.getLevel(character, Skill.doctor)}',
                            ),
                            StatText(
                              icon: '🐴',
                              value:
                                  '${SkillService.getLevel(character, Skill.vet)}',
                            ),
                            StatText(
                              icon: '🔧',
                              value:
                                  '${SkillService.getLevel(character, Skill.mechanic)}',
                            ),
                            StatText(
                              icon: '👁',
                              value:
                                  '${SkillService.getLevel(character, Skill.scout)}',
                            ),
                            StatText(
                              icon: '⚔',
                              value:
                                  '${SkillService.getLevel(character, Skill.combat)}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  // Full-height action column
                  SizedBox(
                    width: 84,
                    child: AppButton(
                      text:
                          'Hire\n🪙\n${recruit.hiringCost.toStringAsFixed(0)}',
                      onPressed:
                          canHire
                              ? () {
                                  setState(
                                    () {
                                      widget
                                              .playerState
                                              .caravan
                                              .gold -=
                                          recruit.hiringCost;

                                      RecruitmentService
                                          .recruit(
                                        recruit:
                                            character,
                                        companions: widget
                                            .playerState
                                            .caravan
                                            .companions,
                                      );

                                      recruits
                                          .removeAt(
                                        index,
                                      );
                                    },
                                  );
                                }
                              : null,
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