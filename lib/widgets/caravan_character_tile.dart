import 'package:flutter/material.dart';

import '../../core/caravan/caravan_service.dart';
import '../../core/models/animal.dart';
import '../../core/models/caravan.dart';
import '../../core/models/character.dart';
import '../../core/models/vehicle.dart';

class CaravanCharacterTile
    extends StatelessWidget {
  final Caravan caravan;
  final Character character;
  final String role;
  final IconData icon;
  final VoidCallback onChanged;

  const CaravanCharacterTile({
    super.key,
    required this.caravan,
    required this.character,
    required this.role,
    required this.icon,
    required this.onChanged,
  });

  void _mountAnimal(
    Animal animal,
  ) {
    character.mountedVehicle = null;
    character.mountedAnimal = animal;
  }

  void _mountVehicle(
    Vehicle vehicle,
  ) {
    character.mountedAnimal = null;
    character.mountedVehicle = vehicle;
  }

  void _dismount() {
    character.mountedAnimal = null;
    character.mountedVehicle = null;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(character.name),
        subtitle: Text(
          '$role\n'
          'Age: ${character.ageYears}\n'
          'Weight: ${character.weightKg.toStringAsFixed(0)} kg\n'
          'Speed: ${character.speed.toStringAsFixed(1)}\n'
          'Effective Speed: ${character.effectiveSpeed.toStringAsFixed(1)}\n'
          'Mount: '
          '${character.mountedAnimal?.type.name ?? character.mountedVehicle?.type.name ?? 'None'}\n'
          'HP: ${character.hp.toStringAsFixed(0)}'
          ' / '
          '${character.maxHp.toStringAsFixed(0)}'
          '${role == 'Companion'
              ? '\nWage: ${character.wagePerDay.toStringAsFixed(0)} / day'
              : ''}',
        ),
        trailing:
            PopupMenuButton<Object>(
          onSelected: (value) {
            if (value == 'dismount') {
              _dismount();
              onChanged();
              return;
            }

            if (value is Animal) {
              _mountAnimal(value);
              onChanged();
              return;
            }

            if (value is Vehicle) {
              _mountVehicle(value);
              onChanged();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<Object>(
              value: 'dismount',
              child: Text(
                'Dismount',
              ),
            ),

            const PopupMenuDivider(),

            ...caravan.animals
                .where(
                  (animal) =>
                      CaravanService
                          .canMountAnimal(
                    caravan: caravan,
                    character: character,
                    animal: animal,
                  ),
                )
                .map(
                  (animal) =>
                      PopupMenuItem<Object>(
                    value: animal,
                    child: Text(
                      'Ride ${animal.type.name}',
                    ),
                  ),
                ),

            ...caravan.vehicles
                .where(
                  (vehicle) =>
                      CaravanService
                          .canMountVehicle(
                    vehicle: vehicle,
                  ),
                )
                .map(
                  (vehicle) =>
                      PopupMenuItem<Object>(
                    value: vehicle,
                    child: Text(
                      'Ride ${vehicle.type.name}',
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}