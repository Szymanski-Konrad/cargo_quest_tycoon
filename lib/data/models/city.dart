import 'package:cargo_quest_tycoon/data/models/cargo.dart';
import 'package:cargo_quest_tycoon/data/models/map_tile_position.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';
part 'city.g.dart';

const _radius = 20;

@freezed
class City with _$City {
  const City._();

  factory City({
    required String id,
    required MapTilePosition position,
    required String name,
    @Default(0) int level,
    DateTime? nextRefreshTime,
    @Default(60) int refreshInterval,
    @Default([]) List<Cargo> cargos,
  }) = _City;

  bool isTapped(Offset tapPoint) {
    if (tapPoint.dx > position.x - _radius &&
        tapPoint.dx < position.x + _radius &&
        tapPoint.dy > position.y - _radius &&
        tapPoint.dy < position.y + _radius) {
      return true;
    }

    return false;
  }

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
