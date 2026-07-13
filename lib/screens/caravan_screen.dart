import 'package:flutter/material.dart';

import '../../data/animal_data.dart';
import '../../data/vehicle_data.dart';

import '../widgets/caravan_animal_tile.dart';
import '../widgets/caravan_character_tile.dart';
import '../widgets/caravan_vehicle_tile.dart';

import '../../core/caravan/caravan_service.dart';
import '../../core/models/animal.dart';
import '../../core/models/caravan.dart';
import '../../core/models/vehicle.dart';

import 'character_screen.dart';

class CaravanScreen extends StatefulWidget {
  final Caravan caravan;

  const CaravanScreen({
    super.key,
    required this.caravan,
  });

  @override
  State<CaravanScreen> createState() =>
      _CaravanScreenState();
}

class _CaravanScreenState
    extends State<CaravanScreen> {
  Caravan get caravan =>
      widget.caravan;

  void _addDonkey() {
    setState(() {
      caravan.animals.add(
        Animal(
          type: donkey,
          gender: AnimalGender.male,
          hp: donkey.maxHp,
          ageYears: 5,
          adultWeightKg:
              donkey.averageAdultWeightKg,
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
  Widget build(
    BuildContext context,
  ) {
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
                      fontWeight:
                          FontWeight.bold,
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
                        child:
                            const Text(
                          '+ Donkey',
                        ),
                      ),
                      ElevatedButton(
                        onPressed:
                            _addCart,
                        child:
                            const Text(
                          '+ Cart',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            'People',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CharacterScreen(
          character: caravan.leader,
          caravan: caravan,
        ),
      ),
    );
  },
  child: CaravanCharacterTile(
    caravan: caravan,
    character: caravan.leader,
    role: 'Leader',
    icon: Icons.person,
    onChanged: () {
      setState(() {});
    },
  ),
),

          if (caravan
              .companions
              .isEmpty)
            const Card(
              child: Padding(
                padding:
                    EdgeInsets.all(
                  12,
                ),
                child: Text(
                  'No companions.',
                ),
              ),
            ),

...caravan.companions.map(
  (companion) => GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CharacterScreen(
            character: companion,
            caravan: caravan,
          ),
        ),
      );
    },
    child: CaravanCharacterTile(
      caravan: caravan,
      character: companion,
      role: 'Companion',
      icon: Icons.people,
      onChanged: () {
        setState(() {});
      },
    ),
  ),
),

          const SizedBox(
            height: 16,
          ),

          const Text(
            'Animals',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          ...caravan.animals.map(
            (animal) =>
                CaravanAnimalTile(
              caravan: caravan,
              animal: animal,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            'Vehicles',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          ...caravan.vehicles.map(
            (vehicle) =>
                CaravanVehicleTile(
              caravan: caravan,
              vehicle: vehicle,
              onChanged: () {
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}