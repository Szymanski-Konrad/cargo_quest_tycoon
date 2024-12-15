import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/vehicle_part_type.dart';

part 'vehicle_part.freezed.dart';
part 'vehicle_part.g.dart';

@freezed
class VehiclePart with _$VehiclePart {
  factory VehiclePart({
    required String id,
    required String name,
    required int cost,
    required int premiumCost,
    required int quality,
    required VehiclePartType type,
    required double value,
  }) = _VehiclePart;

  factory VehiclePart.fromJson(Map<String, dynamic> json) =>
      _$VehiclePartFromJson(json);
  const VehiclePart._();

  double get realValue => value * 100 / quality;
}
