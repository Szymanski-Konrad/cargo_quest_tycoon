import 'dart:ui' as ui;

import 'package:cargo_quest_tycoon/core/constants/game_constants.dart';
import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class GameTile extends PositionComponent
    with HasWorldReference<TransportWorld>, TapCallbacks {
  MapTileType type;
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
        );

  @override
  void onTapUp(TapUpEvent event) {
    if (type == MapTileType.headquarter) {
      world.openVehicleShop(position);
    }

    super.onTapUp(event);
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = isDiscovered ? type.color : type.color.withOpacity(0.5);
    final rect = Offset.zero & size.toSize();

    ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText(type.isDrivable ? '$number' : 'x');

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x));

    canvas.drawRect(rect, paint);
    canvas.drawParagraph(paragraph, rect.topLeft);
  }
}
