abstract class GameConstants {
  static const int maxLevels = 100;
  static const int maxFuelStationLevel = 10;

  /// Number of tiles on the map
  static const int mapSize = mapXSize * mapYSize;
  static const int mapXSize = 30;
  static const int mapYSize = 20;

  /// Map tile size in pixels
  static const double mapTileSize = 48.0;
  static const double mapXSizePx = mapXSize * mapTileSize;
  static const double mapYSizePx = mapYSize * mapTileSize;

  /// Rate of UI updates
  static const Duration gameTickDuration = Duration(milliseconds: 1000);
}
