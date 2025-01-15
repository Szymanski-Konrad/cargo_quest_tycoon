import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'game_tile.dart';
import 'transport_world.dart';

class GarageTile extends GameTile
    with HasWorldReference<TransportWorld>, TapCallbacks {
  GarageTile({
    required super.gridPosition,
    required super.type,
    required this.garageName,
  });

  final String garageName;

  @override
  void onTapUp(TapUpEvent event) {
    world.openGarageOverview(gridPosition);
  }

  @override
  void render(Canvas canvas) {
    final ui.Paint paint = Paint()..color = type.color;
    final ui.Rect rect = Offset.zero & size.toSize();

    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.teal))
      ..addText(garageName);

    final ui.Paragraph paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x));

    canvas.drawRect(rect, paint);
    canvas.drawParagraph(paragraph, rect.topLeft);
    return;
  }
}
