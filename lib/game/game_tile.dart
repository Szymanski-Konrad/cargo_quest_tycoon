import 'dart:ui' as ui;

import 'package:cargo_quest_tycoon/core/constants/game_constants.dart';
import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameTile extends PositionComponent {
  final MapTileType type;
  final Vector2 gridPosition;
  final int number;
  //TODO: Default should be false
  bool isDiscovered = true;

  GameTile({
    required this.type,
    required this.gridPosition,
    required this.number,
  }) : super(
          size: Vector2.all(GameConstants.mapTileSize),
          position: gridPosition * (GameConstants.mapTileSize),
        ) {}

  @override
  void render(Canvas canvas) {
    // super.render(canvas);
    final paint = Paint();

    if (!isDiscovered) {
      paint.color = Colors.black.withOpacity(0.8);
    } else {
      switch (type) {
        case MapTileType.road:
          paint.color = Colors.grey;
          break;
        case MapTileType.city:
          paint.color = Colors.brown;
          break;
        case MapTileType.port:
          paint.color = Colors.cyanAccent;
          break;
        case MapTileType.forest:
          paint.color = Colors.green;
          break;
        case MapTileType.mountain:
          paint.color = Colors.grey;
          break;
        case MapTileType.water:
          paint.color = Colors.blue;
          break;
        case MapTileType.empty:
          paint.color = Colors.black;
          break;
        case MapTileType.headquarter:
          paint.color = Colors.amber;
          break;
      }
    }

    final relative = position.toPositionedRect(size);

    final test = Rect.fromLTRB(
      canvas.getDestinationClipBounds().left - canvas.getLocalClipBounds().left,
      canvas.getDestinationClipBounds().top - canvas.getLocalClipBounds().top,
      canvas.getDestinationClipBounds().right -
          canvas.getLocalClipBounds().right,
      canvas.getDestinationClipBounds().bottom -
          canvas.getLocalClipBounds().bottom,
    );

    final rect = Offset.zero & size.toSize();

    ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText('$number');

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x));

    canvas.drawRect(rect, paint);
    canvas.drawParagraph(paragraph, rect.topLeft);
  }
}
