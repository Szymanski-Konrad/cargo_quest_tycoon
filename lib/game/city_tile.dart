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
    required super.number,
  }) : super(
          type: MapTileType.city,
        );

  @override
  void onTapUp(TapUpEvent event) {
    if (!isDiscovered) {
      discoverTile();
      return;
    }

    world.openCityOverview(gridPosition);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    return;
    // if (!isDiscovered) {
    //   super.render(canvas);
    //   return;
    // }
    // final ui.Paint paint = Paint()
    //   ..color = isDiscovered ? type.color : type.color.withOpacity(0.5);
    // final ui.Rect rect = Offset.zero & size.toSize();

    // final ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
    //   textAlign: TextAlign.center,
    //   fontSize: 10,
    // ))
    //   ..pushStyle(ui.TextStyle(color: Colors.white))
    //   ..addText(type.isDrivable ? '$number' : 'x');

    // final ui.Paragraph paragraph = builder.build()
    //   ..layout(ui.ParagraphConstraints(width: size.x));

    // canvas.drawRect(rect, paint);
    // canvas.drawParagraph(paragraph, rect.topLeft);
  }
}
