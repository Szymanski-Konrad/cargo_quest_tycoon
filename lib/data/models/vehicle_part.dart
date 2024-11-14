import 'package:cargo_quest_tycoon/data/enums/vehicle_part_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle_part.freezed.dart';
part 'vehicle_part.g.dart';

@freezed
class VehiclePart with _$VehiclePart {
  const VehiclePart._();

  factory VehiclePart({
    required String id,
    required String name,
    required int cost,
    required int premiumCost,
    required int quality,
    required VehiclePartType type,
    required double value,
  }) = _VehiclePart;

  double get realValue => value * 100 / quality;

  factory VehiclePart.fromJson(Map<String, dynamic> json) =>
      _$VehiclePartFromJson(json);
}
