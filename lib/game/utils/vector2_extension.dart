import 'package:flame/components.dart';

import '../../core/constants/game_constants.dart';
import '../../data/models/map_tile_position.dart';

extension Vector2Extension on Vector2 {
  MapTilePosition toMapTilePosition() => MapTilePosition(x: x, y: y);
}

extension MapTilePositionExtension on MapTilePosition {
  Vector2 toVector2() => Vector2(x, y);
  Vector2 toMapSizeVector() => Vector2(
        x * GameConstants.mapTileSize,
        y * GameConstants.mapTileSize,
      );
}
