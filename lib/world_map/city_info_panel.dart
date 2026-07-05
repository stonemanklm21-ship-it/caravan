import 'package:flutter/material.dart';

import '../core/models/city.dart';

class CityInfoPanel extends StatelessWidget {
  final City city;

  final VoidCallback onTravel;

  const CityInfoPanel({
    super.key,
    required this.city,
    required this.onTravel,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(
          16,
        ),
        color: Colors.white,
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              city.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge,
            ),

            Text(
              'Population: ${city.population}',
            ),

            Text(
              'Industries: ${city.industries.length}',
            ),

            const SizedBox(
              height: 8,
            ),

            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (city.hasVet)
                  const Chip(
                    label: Text(
                      'Vet',
                    ),
                  ),
                if (city.hasDoctor)
                  const Chip(
                    label: Text(
                      'Doctor',
                    ),
                  ),
                if (city.hasCartwright)
                  const Chip(
                    label: Text(
                      'Cartwright',
                    ),
                  ),
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            ElevatedButton(
              onPressed: onTravel,
              child: const Text(
                'Travel',
              ),
            ),
          ],
        ),
      ),
    );
  }
}