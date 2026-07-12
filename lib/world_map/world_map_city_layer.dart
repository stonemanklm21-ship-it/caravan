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

          final markerSize =
              (20 * camera.zoom)
                  .clamp(
            10.0,
            32.0,
          );

          return Stack(
            children: [
              Positioned(
                left:
                    position.dx -
                    (markerSize + 8) / 2,
                top:
                    position.dy -
                    (markerSize + 8) / 2,
                child: SizedBox(
                  width:
                      markerSize + 8,
                  height:
                      markerSize + 8,
                  child: Stack(
                    alignment:
                        Alignment.center,
                    children: [
                      if (isSelected)
                        Container(
                          width:
                              markerSize + 8,
                          height:
                              markerSize + 8,
                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape
                                    .circle,
                            border:
                                Border.all(
                              color:
                                  Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      Container(
                        width:
                            markerSize,
                        height:
                            markerSize,
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.black,
                          shape:
                              BoxShape
                                  .circle,
                          border:
                              Border.all(
                            color:
                                Colors.white,
                            width: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left:
                    position.dx - 50,
                top:
                    position.dy +
                    markerSize / 2 +
                    4,
                child: SizedBox(
                  width: 100,
                  child: Text(
                    city.name,
                    textAlign:
                        TextAlign.center,
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 12,
                      shadows: [
                        Shadow(
                          color:
                              Colors.black,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ).toList(),
    );
  }
}