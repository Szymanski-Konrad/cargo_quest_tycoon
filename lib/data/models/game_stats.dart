import 'package:cargo_quest_tycoon/data/models/city.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_stats.freezed.dart';
part 'game_stats.g.dart';

@freezed
class GameStats with _$GameStats {
  const factory GameStats({
    required int level,
    required int exp,
    required int expToNextLevel,
    @Default(0) int coins,

    /// Premium currency
    @Default(0) int roadStars,
    @Default(0) int crates,
    @Default(0) int premiumCrates,
    @Default([]) List<City> unlockedCities,
  }) = _GameStats;

  factory GameStats.fromJson(Map<String, dynamic> json) =>
      _$GameStatsFromJson(json);
}
