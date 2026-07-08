import 'package:flutter/material.dart';

import '../core/city/recruitment_service.dart';
import '../core/models/player_state.dart';
import '../core/models/recruit.dart';

class RecruitmentScreen
    extends StatefulWidget {
  final PlayerState playerState;

  const RecruitmentScreen({
    super.key,
    required this.playerState,
  });

  @override
  State<RecruitmentScreen>
      createState() =>
          _RecruitmentScreenState();
}

class _RecruitmentScreenState
    extends State<RecruitmentScreen> {
  late List<Recruit> recruits;

  @override
  void initState() {
    super.initState();

    recruits =
        RecruitmentService
            .generateRecruits(
      tier:
          RecruitmentMarketTier.basic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recruitment Hall',
        ),
      ),
      body: ListView.builder(
        itemCount: recruits.length,
        itemBuilder:
            (context, index) {
          final recruit =
              recruits[index];

          final character =
              recruit.character;

          final canHire =
              widget
                  .playerState
                  .caravan
                  .gold >=
              recruit.hiringCost;

          return Card(
            margin:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              title: Text(
                '${character.name} (${character.ageYears})',
              ),
              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    '🩺${character.doctorSkill}  '
                    '🐴${character.vetSkill}  '
                    '🔧${character.mechanicSkill}  '
                    '👁️${character.scoutSkill}  '
                    '⚔️${character.combatSkill}',
                  ),
                  Text(
  '🏃 ${character.speed.toStringAsFixed(1)} km/h',
),
                  Text(
                    'HP: '
                    '${character.hp.toStringAsFixed(0)}'
                    ' / '
                    '${character.maxHp.toStringAsFixed(0)}',
                  ),
                  Text(
                    '📦 '
                    '${character.cargoCapacityKg.toStringAsFixed(1)} kg',
                  ),
                  Text(
                    '🍖 '
                    '${character.caloriesPerDay.toStringAsFixed(0)} / day',
                  ),
                  Text(
                    '💧 '
                    '${character.waterPerDay.toStringAsFixed(1)} / day',
                  ),
                  Text(
                    '💰 Wage: '
                    '${character.wagePerDay.toStringAsFixed(0)} / day',
                  ),
                  Text(
                    '🏷️ Hire: '
                    '${recruit.hiringCost.toStringAsFixed(0)}',
                  ),
                ],
              ),
              trailing:
                  ElevatedButton(
                onPressed:
                    canHire
                        ? () {
                            setState(() {
                              widget
                                  .playerState
                                  .caravan
                                  .gold -=
                                  recruit
                                      .hiringCost;

                              RecruitmentService
                                  .recruit(
                                recruit:
                                    character,
                                companions: widget
                                    .playerState
                                    .caravan
                                    .companions,
                              );

                              recruits.removeAt(
                                index,
                              );
                            });
                          }
                        : null,
                child: const Text(
                  'Hire',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}