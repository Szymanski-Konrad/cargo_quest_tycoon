part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => <Object>[];
}

final class LevelUp extends GameEvent {
  const LevelUp();
}

final class GainExp extends GameEvent {
  const GainExp(this.exp);
  final int exp;

  @override
  List<Object> get props => <Object>[exp];
}

final class GainCoins extends GameEvent {
  const GainCoins(this.coins);
  final int coins;

  @override
  List<Object> get props => <Object>[coins];
}

final class SpendCoins extends GameEvent {
  const SpendCoins(this.coins);
  final int coins;

  @override
  List<Object> get props => <Object>[coins];
}

final class GainRoadStars extends GameEvent {
  const GainRoadStars(this.roadStars);
  final int roadStars;

  @override
  List<Object> get props => <Object>[roadStars];
}

final class GainCrates extends GameEvent {
  const GainCrates(this.crates);
  final int crates;

  @override
  List<Object> get props => <Object>[crates];
}

final class GainPremiumCrates extends GameEvent {
  const GainPremiumCrates(this.premiumCrates);
  final int premiumCrates;

  @override
  List<Object> get props => <Object>[premiumCrates];
}

final class UnlockTile extends GameEvent {
  const UnlockTile({
    required this.tile,
    required this.cost,
    required this.onUnlock,
  });
  final MapTile tile;
  final int cost;
  final VoidCallback onUnlock;

  @override
  List<Object> get props => [
        tile,
        cost,
        onUnlock,
      ];
}
