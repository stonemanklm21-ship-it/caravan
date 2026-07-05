import 'package:flutter/material.dart';

import '../core/models/city.dart';
import 'world_map_camera.dart';

class WorldMapCityLayer
    extends StatelessWidget {
  final List<City> cities;

  final City? selectedCity;

  final WorldMapCamera camera;

  final Size viewportSize;

  const WorldMapCityLayer({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.camera,
    required this.viewportSize,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Stack(
      children: cities.map(
        (city) {
          final position =
              camera.worldToScreen(
            worldX: city.x,
            worldY: city.y,
            viewportSize:
                viewportSize,
          );

          final isSelected =
              city == selectedCity;

          return Positioned(
            left: position.dx,
            top: position.dy,
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_city,
                  color: isSelected
                      ? Colors.blue
                      : Colors.black,
                  size:
                      32 *
                      camera.zoom.clamp(
                        0.5,
                        2.0,
                      ),
                ),
                Text(city.name),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}