abstract class GameConstants {
  static const int maxLevels = 100;
  static const int maxFuelStationLevel = 10;

  /// Number of tiles on the map
  static const int mapSize = mapXSize * mapYSize;
  // Remember to keep this values odd
  static const int mapXSize = 24;
  static const int mapYSize = 18;

  /// Map tile size in pixels
  static const double mapTileSize = 48.0;
  static const double mapXSizePx = mapXSize * mapTileSize;
  static const double mapYSizePx = mapYSize * mapTileSize;

  /// Rate of UI updates
  static const Duration gameTickDuration = Duration(milliseconds: 1000);

  // TODO(me): Use it in calculations
  static const double kilometersPerPixel = 1.0;
}
