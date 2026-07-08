import 'package:flutter/material.dart';

import '../../data/game_data.dart';
import '../../core/city/person_health_service.dart';
import '../../core/models/character.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor',
        ),
      ),
      body: ListView.builder(
        itemCount: characters.length,
        itemBuilder:
            (context, index) {
          final character =
              characters[index];

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

          return Card(
            margin:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              title: Text(
                index == 0
                    ? '${character.name} (Leader)'
                    : character.name,
              ),
              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    'HP: ${character.hp.toStringAsFixed(0)}'
                    ' / ${character.maxHp.toStringAsFixed(0)}',
                  ),
                  Text(
                    'Doctor Skill: ${character.doctorSkill}',
                  ),
                  Text(
                    'Cost: ${cost.toStringAsFixed(0)}',
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed:
                    !canHeal ||
                            caravan.gold <
                                cost
                        ? null
                        : () {
                            setState(() {
                              caravan.gold -=
                                  cost;

                              CharacterHealthService
                                  .heal(
                                character,
                              );
                            });
                          },
                child: const Text(
                  'Treat',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}