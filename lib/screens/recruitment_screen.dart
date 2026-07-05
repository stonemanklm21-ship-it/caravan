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
            .generateRecruits();
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
                character.name,
              ),
              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    'Age: ${character.ageYears}',
                  ),
                  Text(
                    'HP: '
                    '${character.hp.toStringAsFixed(0)}'
                    ' / '
                    '${character.maxHp.toStringAsFixed(0)}',
                  ),
                  Text(
                    'Cargo Capacity: '
                    '${character.cargoCapacityKg.toStringAsFixed(1)} kg',
                  ),
                  Text(
                    'Food: '
                    '${character.caloriesPerDay.toStringAsFixed(0)} / day',
                  ),
                  Text(
                    'Water: '
                    '${character.waterPerDay.toStringAsFixed(1)} / day',
                  ),
                  Text(
                    'Wage: '
                    '${character.wagePerDay.toStringAsFixed(0)} / day',
                  ),
                  Text(
                    'Hiring Cost: '
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