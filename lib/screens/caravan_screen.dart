import 'package:flutter/material.dart';

import '../../data/animal_data.dart';
import '../../data/vehicle_data.dart';

import '../../core/caravan/animal_service.dart';
import '../../core/caravan/caravan_service.dart';
import '../../core/caravan/vehicle_service.dart';
import '../../core/models/animal.dart';
import '../../core/models/caravan.dart';
import '../../core/models/vehicle.dart';
import '../../core/world/calendar_service.dart';

class CaravanScreen extends StatefulWidget {
  final Caravan caravan;

  const CaravanScreen({super.key, required this.caravan,});

  @override State<CaravanScreen> createState() => _CaravanScreenState();}

class _CaravanScreenState extends State<CaravanScreen> {
  Caravan get caravan => widget.caravan;

  void _addDonkey() {
    setState(() {
      caravan.animals.add(
        Animal(
          type: donkey,
          gender: AnimalGender.male,
          hp: donkey.maxHp,
          ageYears: 5,
          adultWeightKg:
              donkey
                  .averageAdultWeightKg,
        ),
      );
    });
  }

  void _addCart() {
    setState(() {
      caravan.vehicles.add(
        Vehicle(
          type: cart,
          condition:
              cart.maxCondition,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Caravan',
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.all(
                12,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  const Text(
                    'Summary',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Cargo Capacity: '
                    '${caravan.cargoCapacityKg.toStringAsFixed(1)} kg',
                  ),
                  Text(
                    'Cargo Weight: '
                    '${caravan.cargoWeightKg.toStringAsFixed(1)} kg',
                  ),
                Text(
  'Available Capacity: '
  '${caravan.availableCapacityKg.toStringAsFixed(1)} kg',
),
Text(
  'Speed: '
  '${caravan.speed.toStringAsFixed(1)} km/h',
),
const SizedBox(
  height: 8,
),
const Text(
  'Skills',
  style: TextStyle(
    fontWeight: FontWeight.bold,
  ),
),
Text(
  '🩺 Doctor: ${caravan.doctorSkill}',
),
Text(
  '🐴 Vet: ${caravan.vetSkill}',
),
Text(
  '🔧 Mechanic: ${caravan.mechanicSkill}',
),
Text(
  '👁️ Scout: ${caravan.scoutSkill}',
),
Text(
  '⚔️ Combat: ${caravan.combatSkill}',
),
const SizedBox(
  height: 8,
),
Text(
  'Water / Day: '
  '${caravan.waterRequirementPerDay.toStringAsFixed(1)}',
),
Text(
  'Calories / Day: '
  '${caravan.calorieRequirementPerDay.toStringAsFixed(0)}',
),
Text(
  'Wages / Day: '
  '${caravan.wagesPerDay.toStringAsFixed(0)}',
),
Text(
  'Forage / Day: '
  '${caravan.forageRequirementPerDay.toStringAsFixed(1)}',
),
                  Text(
                    'Can Travel: '
                    '${CaravanService.canTravel(caravan) ? 'Yes' : 'No'}',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _addDonkey,
                        child: const Text(
                          '+ Donkey',
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            _addCart,
                        child: const Text(
                          '+ Cart',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'People',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: Text(
                caravan.leader.name,
              ),
              subtitle: Text(
                'Leader\n'
                'Age: ${caravan.leader.ageYears}\n'
                'HP: ${caravan.leader.hp.toStringAsFixed(0)}'
                ' / '
                '${caravan.leader.maxHp.toStringAsFixed(0)}',
              ),
            ),
          ),

          if (caravan.companions.isEmpty)
            const Card(
              child: Padding(
                padding:
                    EdgeInsets.all(12),
                child: Text(
                  'No companions.',
                ),
              ),
            ),

          ...caravan.companions.map(
            (companion) => Card(
              child: ListTile(
                leading: const Icon(
                  Icons.people,
                ),
                title: Text(
                  companion.name,
                ),
                subtitle: Text(
                  'Companion\n'
                  'Age: ${companion.ageYears}\n'
                  'HP: ${companion.hp.toStringAsFixed(0)}'
                  ' / '
                  '${companion.maxHp.toStringAsFixed(0)}\n'
                  'Wage: ${companion.wagePerDay.toStringAsFixed(0)} / day',
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Animals',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          ...caravan.animals.map(
            (animal) =>
                _animalTile(animal),
          ),

          const SizedBox(height: 16),

          const Text(
            'Vehicles',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          ...caravan.vehicles.map(
            (vehicle) =>
                _vehicleTile(vehicle),
          ),
        ],
      ),
    );
  }

  Widget _animalTile(
    Animal animal,
  ) {
    Vehicle? assignedVehicle;

    for (final vehicle
        in caravan.vehicles) {
      if (identical(
        vehicle.draftAnimal,
        animal,
      )) {
        assignedVehicle = vehicle;
        break;
      }
    }

    return Card(
      child: ListTile(
        title: Text(
          animal.type.name,
        ),
        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Age: ${CalendarService.formatAge(animal.ageYears)}',
            ),
            Text(
              'Weight: ${AnimalService.weightKg(animal).toStringAsFixed(1)} kg',
            ),
            Text(
              'HP: ${animal.hp.toStringAsFixed(0)} / ${animal.type.maxHp.toStringAsFixed(0)}',
            ),
            Text(
              'Capacity: ${AnimalService.cargoCapacityKg(animal).toStringAsFixed(1)} kg',
            ),
            Text(
              'Assigned Vehicle: ${assignedVehicle?.type.name ?? 'None'}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _vehicleTile(
    Vehicle vehicle,
  ) {
    return Card(
      child: ListTile(
        title: Text(
          vehicle.type.name,
        ),
        subtitle: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Condition: ${vehicle.condition.toStringAsFixed(1)} / ${vehicle.type.maxCondition.toStringAsFixed(0)}',
            ),
            Text(
              'Operational: ${VehicleService.operational(vehicle) ? 'Yes' : 'No'}',
            ),
            Text(
              'Required Pulling Capacity: ${vehicle.type.requiredPullingCapacityKg.toStringAsFixed(1)} kg',
            ),
            Text(
              'Assigned Animal: ${vehicle.draftAnimal?.type.name ?? 'None'}',
            ),
            Text(
              'Can Pull: ${VehicleService.canPull(vehicle) ? 'Yes' : 'No'}',
            ),
            Text(
              'Cargo Capacity: ${VehicleService.cargoCapacityKg(vehicle).toStringAsFixed(1)} kg',
            ),
          ],
        ),
        trailing:
            PopupMenuButton<String>(
          onSelected: (value) {
            if (value ==
                'unassign') {
              setState(() {
                CaravanService
                    .unassignAnimal(
                  vehicle,
                );
              });
              return;
            }

            final animal =
                caravan.animals
                    .firstWhere(
              (animal) =>
                  animal.type.id ==
                  value,
            );

            setState(() {
              CaravanService
                  .assignAnimal(
                vehicle: vehicle,
                animal: animal,
              );
            });
          },
          itemBuilder:
              (context) => [
            const PopupMenuItem(
              value: 'unassign',
              child: Text(
                'Unassign',
              ),
            ),
            ...caravan.animals
                .where(
                  (animal) =>
                      !CaravanService
                          .animalAssigned(
                    caravan,
                    animal,
                  ),
                )
                .map(
                  (animal) =>
                      PopupMenuItem(
                    value:
                        animal.type.id,
                    child: Text(
                      animal.type.name,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}