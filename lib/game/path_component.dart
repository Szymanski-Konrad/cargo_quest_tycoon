import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'path_finder.dart';
import 'transport_world.dart';

class PathComponent extends PositionComponent
    with HasWorldReference<TransportWorld> {
  PathComponent({
    required this.pathPoints,
    required this.color,
    required this.pathId,
  });
  final List<PathTile> pathPoints;
  final Color color;
  final String pathId;

  @override
  void render(Canvas canvas) {
    if (pathPoints.length < 2) {
      return;
    }

    final Path path = Path();
    path.moveTo(pathPoints[0].position.x, pathPoints[0].position.y);

    for (int i = 1; i < pathPoints.length; i++) {
      final PathTile point = pathPoints[i];
      path.lineTo(point.position.x, point.position.y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 2,
    );
    super.render(canvas);
  }
}
