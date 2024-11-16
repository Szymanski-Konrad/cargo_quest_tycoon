abstract class GameConstants {
  static const int maxLevels = 100;
  static const int maxFuelStationLevel = 10;

  /// Number of tiles on the map
  static const int mapSize = 64;
  static const int mapXSize = 8;
  static const int mapYSize = 8;

  /// Map tile size in pixels
  static const double mapTileSizeX = 64.0;
  static const double mapTileSizeY = 64.0;

  /// Rate of UI updates
  static const Duration gameTickDuration = Duration(milliseconds: 1000);
}
