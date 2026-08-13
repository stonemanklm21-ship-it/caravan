import 'package:flutter/material.dart';
import 'encounter_action.dart';
import 'caravan_encounter.dart';

class CaravanEncounterDialog {
static Future<EncounterAction?> show(
  BuildContext context,
  CaravanEncounter encounter,
) async {
  return showDialog<EncounterAction>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            encounter.title,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: encounter.actions.map(
              (action) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      action,
                    );
                  },
                  child: Text(
                    action.name,
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}