import 'package:flutter/material.dart';
import 'world_map_camera.dart';

class WorldMapGestureLayer
    extends StatefulWidget {
  final WorldMapCamera camera;
  final Widget child;
  final VoidCallback onCameraChanged;
  final VoidCallback onManualMove;

  const WorldMapGestureLayer({
    super.key,
    required this.camera,
    required this.child,
    required this.onCameraChanged,
    required this.onManualMove,
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
        final viewportSize =
            MediaQuery.sizeOf(
          context,
        );

        if (details
                .focalPointDelta
                .distance >
            0) {
          widget.onManualMove();
        }

        widget.camera.x -=
            details
                    .focalPointDelta.dx /
                widget.camera.zoom;

        widget.camera.y -=
            details
                    .focalPointDelta.dy /
                widget.camera.zoom;

        final minZoom =
            widget.camera.minimumZoom(
          viewportSize:
              viewportSize,
        );

        widget.camera.zoom =
            (_startingZoom *
                    details.scale)
                .clamp(
          minZoom,
          4.0,
        );

        widget.camera.clampToWorld(
          viewportSize:
              viewportSize,
        );

        widget.onCameraChanged();
      },
      child: widget.child,
    );
  }
}