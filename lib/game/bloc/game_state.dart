part of 'game_bloc.dart';

@freezed
class GameState with _$GameState {
  const GameState._();

  factory GameState.initial() => GameState(
        level: 1,
        exp: 0,
        expToNextLevel: 100,
        coins: 600,
      );

  factory GameState({
    required int level,
    required int exp,
    required int expToNextLevel,
    @Default(0) int coins,

    /// Premium currency
    @Default(0) int roadStars,
    @Default(0) int crates,
    @Default(0) int premiumCrates,
    @Default([]) List<MapTile> unlockedTiles,

    // Control values
    @Default(false) bool showBuyTruckDialog,
  }) = _GameState;
}
