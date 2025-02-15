part of 'game_bloc.dart';

@freezed
class GameState with _$GameState {
  factory GameState({
    required GameStats gameStats,
    @Default([]) List<MapTile> unlockedTiles,
  }) = _GameState;
  const GameState._();

  factory GameState.initial() => GameState(
        gameStats: GameStats(
          coins: 500,
        ),
      );
}
