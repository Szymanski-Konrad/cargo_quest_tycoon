part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class LevelUp extends GameEvent {
  const LevelUp();
}

final class GainExp extends GameEvent {
  final int exp;
  const GainExp(this.exp);

  @override
  List<Object> get props => [exp];
}

final class GainCoins extends GameEvent {
  final int coins;
  const GainCoins(this.coins);

  @override
  List<Object> get props => [coins];
}

final class GainRoadStars extends GameEvent {
  final int roadStars;
  const GainRoadStars(this.roadStars);

  @override
  List<Object> get props => [roadStars];
}

final class GainCrates extends GameEvent {
  final int crates;
  const GainCrates(this.crates);

  @override
  List<Object> get props => [crates];
}

final class GainPremiumCrates extends GameEvent {
  final int premiumCrates;
  const GainPremiumCrates(this.premiumCrates);

  @override
  List<Object> get props => [premiumCrates];
}

final class UnlockTile extends GameEvent {
  final MapTile tile;
  const UnlockTile(this.tile);

  @override
  List<Object> get props => [tile];
}

final class ShowBuyTruckDialog extends GameEvent {
  const ShowBuyTruckDialog();
}

final class HideBuyTruckDialog extends GameEvent {
  const HideBuyTruckDialog();
}
