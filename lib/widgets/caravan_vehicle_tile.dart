import 'package:flutter/material.dart';

import '../../core/caravan/animal_service.dart';
import '../../core/caravan/caravan_service.dart';
import '../../core/caravan/vehicle_service.dart';
import '../../core/models/animal.dart';
import '../../core/models/caravan.dart';
import '../../core/models/vehicle.dart';

class CaravanVehicleTile
    extends StatelessWidget {
  final Caravan caravan;
  final Vehicle vehicle;
  final VoidCallback onChanged;

  const CaravanVehicleTile({
    super.key,
    required this.caravan,
    required this.vehicle,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final passengers =
        CaravanService.passengersOf(
      caravan,
      vehicle,
    );

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
            Text(
              'Passengers: ${passengers.isEmpty ? 'None' : passengers.map((e) => e.name).join(', ')}',
            ),
            Text(
              'Passenger Weight: ${CaravanService.passengerWeight(caravan, vehicle).toStringAsFixed(1)} kg',
            ),
          ],
        ),
        trailing:
            PopupMenuButton<Object>(
          onSelected: (value) {
            if (value ==
                'unassign') {
              CaravanService
                  .unassignAnimal(
                vehicle,
              );

              onChanged();
              return;
            }

            if (value is Animal) {
              CaravanService
                  .assignAnimal(
                vehicle: vehicle,
                animal: value,
              );

              onChanged();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<Object>(
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
                  ) &&
                      AnimalService
                              .cargoCapacityKg(
                            animal,
                          ) >=
                          vehicle
                              .type
                              .requiredPullingCapacityKg,
                )
                .map(
                  (animal) =>
                      PopupMenuItem<Object>(
                    value: animal,
                    child: Text(
                      '${animal.type.name} (${AnimalService.cargoCapacityKg(animal).toStringAsFixed(1)} kg)',
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}