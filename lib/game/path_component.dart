import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PathComponent extends PositionComponent
    with HasWorldReference<TransportWorld> {
  final List<Vector2> pathPoints;
  final Color color;
  final String pathId;

  PathComponent({
    required this.pathPoints,
    required this.color,
    required this.pathId,
  });

  @override
  void render(Canvas canvas) {
    if (pathPoints.length < 2) {
      return;
    }

    final path = Path();
    path.moveTo(pathPoints[0].x, pathPoints[0].y);

    for (int i = 1; i < pathPoints.length; i++) {
      final point = pathPoints[i];
      path.lineTo(point.x, point.y);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = 2,
    );
    // TODO: implement render
    super.render(canvas);
  }
}
