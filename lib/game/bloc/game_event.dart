part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class GameLevelUp extends GameEvent {
  const GameLevelUp();
}

final class GameGainExp extends GameEvent {
  final int exp;
  const GameGainExp(this.exp);

  @override
  List<Object> get props => [exp];
}

final class GameGainCoins extends GameEvent {
  final int coins;
  const GameGainCoins(this.coins);

  @override
  List<Object> get props => [coins];
}

final class GameGainRoadStars extends GameEvent {
  final int roadStars;
  const GameGainRoadStars(this.roadStars);

  @override
  List<Object> get props => [roadStars];
}

final class GameGainCrates extends GameEvent {
  final int crates;
  const GameGainCrates(this.crates);

  @override
  List<Object> get props => [crates];
}

final class GameGainPremiumCrates extends GameEvent {
  final int premiumCrates;
  const GameGainPremiumCrates(this.premiumCrates);

  @override
  List<Object> get props => [premiumCrates];
}

final class GameUnlockTile extends GameEvent {
  final MapTile tile;
  const GameUnlockTile(this.tile);

  @override
  List<Object> get props => [tile];
}
