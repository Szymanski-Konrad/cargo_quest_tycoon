import 'package:freezed_annotation/freezed_annotation.dart';

import 'city.dart';

part 'game_stats.freezed.dart';
part 'game_stats.g.dart';

@freezed
class GameStats with _$GameStats {
  const factory GameStats({
    @Default(1) int level,
    @Default(0) int exp,
    @Default(1000) int expToNextLevel,
    @Default(0) int coins,

    /// Premium currency
    @Default(0) int roadStars,
    @Default(0) int crates,
    @Default(0) int premiumCrates,
  }) = _GameStats;

  factory GameStats.initial() => const GameStats();

  factory GameStats.fromJson(Map<String, dynamic> json) =>
      _$GameStatsFromJson(json);
}
