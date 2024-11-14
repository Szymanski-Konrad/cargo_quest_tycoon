abstract class GameConstants {
  static const int maxLevels = 100;
  static const int maxFuelStationLevel = 10;

  /// Number of tiles on the map
  static const int mapSize = 64;

  /// Map tile size in pixels
  static const int mapTileSize = 32;

  /// Rate of UI updates
  static const Duration gameTickDuration = Duration(milliseconds: 1000);
}
