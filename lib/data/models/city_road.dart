import 'package:cargo_quest_tycoon/data/enums/road_type.dart';
import 'package:cargo_quest_tycoon/data/models/city.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_road.freezed.dart';
part 'city_road.g.dart';

@freezed
class CityRoad with _$CityRoad {
  const factory CityRoad({
    required String id,
    required City startCity,
    required City endCity,
    required double maxSpeed,
    required RoadType roadType,
  }) = _CityRoad;

  factory CityRoad.fromJson(Map<String, dynamic> json) =>
      _$CityRoadFromJson(json);
}
