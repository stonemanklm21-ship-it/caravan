import 'package:flutter/material.dart';


class WorldMapNpcMarker
    extends StatelessWidget {
  final Color color;
  final double zoom;

  const WorldMapNpcMarker({
    super.key,
    required this.zoom,
    this.color = Colors.orange,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final markerSize =
        (18 * zoom).clamp(
          8.0,
          28.0,
        );

    return Container(
      width: markerSize,
      height: markerSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
    );
  }
}