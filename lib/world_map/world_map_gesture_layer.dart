import 'package:flutter/material.dart';

import 'world_map_camera.dart';

class WorldMapGestureLayer
    extends StatefulWidget {
  final WorldMapCamera camera;

  final Widget child;

  final VoidCallback onCameraChanged;

  const WorldMapGestureLayer({
    super.key,
    required this.camera,
    required this.child,
    required this.onCameraChanged,
  });

  @override
  State<WorldMapGestureLayer>
      createState() =>
          _WorldMapGestureLayerState();
}

class _WorldMapGestureLayerState
    extends State<
        WorldMapGestureLayer> {
  double _startingZoom = 1;

  @override
  Widget build(
    BuildContext context,
  ) {
    return GestureDetector(
      behavior:
          HitTestBehavior.opaque,
      onScaleStart: (_) {
        _startingZoom =
            widget.camera.zoom;
      },
      onScaleUpdate: (
        details,
      ) {
        widget.camera.x -=
            details
                    .focalPointDelta.dx /
                widget.camera.zoom;

        widget.camera.y -=
            details
                    .focalPointDelta.dy /
                widget.camera.zoom;

        widget.camera.zoom =
            (_startingZoom *
                    details.scale)
                .clamp(
          0.25,
          4.0,
        );

        widget.onCameraChanged();
      },
      child: widget.child,
    );
  }
}