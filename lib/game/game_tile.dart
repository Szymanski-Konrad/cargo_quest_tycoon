import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../core/constants/game_constants.dart';
import '../data/enums/map_tile_type.dart';
import 'transport_game.dart';

class GameTile extends PositionComponent
    with HasGameRef<TransportGame>, TapCallbacks {
  GameTile({
    required this.type,
    required this.gridPosition,
    required this.number,
    this.isDiscovered = false,
  }) : super(
          size: Vector2.all(GameConstants.mapTileSize),
          position: gridPosition * GameConstants.mapTileSize,
        );
  MapTileType type;
  final Vector2 gridPosition;
  final int number;
  bool isDiscovered = false;

  @override
  void onTapUp(TapUpEvent event) {
    if (isDiscovered) {
      return;
    }
    discoverTile();
    super.onTapUp(event);
  }

  void discoverTile() {
    game.tryToDiscoverTile(gridPosition);
  }

  @override
  void render(Canvas canvas) {
    final ui.Paint paint = Paint()
      ..color = isDiscovered ? type.color : Colors.grey;
    final ui.Rect rect = Offset.zero & size.toSize();

    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText('${gridPosition.x} ${gridPosition.y}');
    // ..addText(type.isDrivable ? type.name.toUpperCase() : 'x ${type.name}');

    final ui.Paragraph paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x));

    canvas.drawRect(rect, paint);
    if (!isDiscovered) {
      paint.color = Colors.black;
      paint.strokeWidth = 2;
      // canvas.drawLine(rect.bottomRight, rect.topLeft, paint);
      // canvas.drawLine(rect.bottomLeft, rect.topRight, paint);
      canvas.drawLine(rect.bottomRight, rect.bottomLeft, paint);
      canvas.drawLine(rect.bottomRight, rect.topRight, paint);

      final ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 10,
      ))
        ..pushStyle(ui.TextStyle(color: Colors.white))
        ..addText(r'1 $');

      final ui.Paragraph paragraph = builder.build()
        ..layout(ui.ParagraphConstraints(
          width: size.x / 2,
        ));
      canvas.drawParagraph(
          paragraph, rect.center - Offset(size.x / 4, size.y / 4));
    } else {
      canvas.drawParagraph(paragraph, rect.topLeft);
    }
  }
}
