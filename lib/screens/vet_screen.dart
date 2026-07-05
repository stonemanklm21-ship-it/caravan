import 'package:flutter/material.dart';

import '../core/city/animal_health_service.dart';
import '../core/models/animal.dart';
import '../core/models/player_state.dart';
import '../core/world/calendar_service.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vet',
        ),
      ),
      body: ListView.builder(
        itemCount: widget
            .playerState
            .caravan
            .animals
            .length,
        itemBuilder:
            (context, index) {
          final animal = widget
              .playerState
              .caravan
              .animals[index];

          final cost =
              AnimalHealthService
                  .healCost(
            animal,
          );

          return _animalCard(
            animal: animal,
            cost: cost,
          );
        },
      ),
    );
  }

  Widget _animalCard({
    required Animal animal,
    required double cost,
  }) {
    final canHeal =
        AnimalHealthService
                .canHeal(animal) &&
            widget.playerState
                    .caravan.gold >=
                cost;

    return Card(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              animal.type.name,
              style:
                  const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Gender: ${animal.gender.name}',
            ),

            Text(
              'Age: ${CalendarService.formatAge(animal.ageYears)}',
            ),

            Text(
              'HP: '
              '${animal.hp.toStringAsFixed(0)}'
              ' / '
              '${animal.type.maxHp.toStringAsFixed(0)}',
            ),

            Text(
              'Heal Cost: '
              '${cost.toStringAsFixed(0)}',
            ),

            const SizedBox(
              height: 8,
            ),

            ElevatedButton(
              onPressed:
                  canHeal
                      ? () {
                          setState(() {
                            widget
                                .playerState
                                .caravan
                                .gold -= cost;

                            AnimalHealthService
                                .heal(
                              animal,
                            );
                          });
                        }
                      : null,
              child: Text(
                AnimalHealthService
                        .canHeal(
                      animal,
                    )
                    ? 'Heal'
                    : 'Healthy',
              ),
            ),
          ],
        ),
      ),
    );
  }
}