import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../data/enums/map_tile_type.dart';
import 'game_tile.dart';
import 'transport_world.dart';

class CityTile extends GameTile
    with HasWorldReference<TransportWorld>, TapCallbacks {
  CityTile({
    required super.gridPosition,
    required super.isDiscovered,
    required this.cityName,
  }) : super(type: MapTileType.city);

  final String cityName;

  @override
  void onTapUp(TapUpEvent event) {
    if (!isDiscovered) {
      discoverTile();
      return;
    }

    world.openCityOverview(gridPosition, cityName);
  }

  @override
  void render(Canvas canvas) {
    if (!isDiscovered) {
      super.render(canvas);
      return;
    }
    final ui.Paint paint = Paint()..color = type.color;
    final ui.Rect rect = Offset.zero & size.toSize();

    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText(cityName);

    final ui.Paragraph paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x));

    canvas.drawRect(rect, paint);
    canvas.drawParagraph(paragraph, rect.topLeft);
    return;
  }
}
