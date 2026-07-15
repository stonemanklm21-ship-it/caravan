import 'package:flutter/material.dart';

import '../../core/caravan/animal_service.dart';
import '../../core/caravan/caravan_service.dart';
import '../../core/models/animal.dart';
import '../../core/models/caravan.dart';
import '../../core/models/vehicle.dart';
import '../../core/world/calendar_service.dart';

class CaravanAnimalTile
    extends StatelessWidget {
  final Caravan caravan;
  final Animal animal;

  const CaravanAnimalTile({
    super.key,
    required this.caravan,
    required this.animal,
  });

  @override
  Widget build(
    BuildContext context,
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

    final rider =
        CaravanService.riderOf(
      caravan,
      animal,
    );

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
              'Rider: ${rider?.name ?? 'None'}',
            ),
            if (rider != null)
              Text(
                'Rider Weight: ${rider.weightKg.toStringAsFixed(1)} kg',
              ),
            Text(
              'Assigned Vehicle: ${assignedVehicle?.type.name ?? 'None'}',
            ),
            Text(
              'Alive: ${animal.alive ? 'Yes' : 'No'}',
            ),
          ],
        ),
      ),
    );
  }
}