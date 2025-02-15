import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/vehicle_type.dart';
import 'vehicle_part.dart';

part 'market_vehicle.freezed.dart';
part 'market_vehicle.g.dart';

@freezed
class MarketVehicle with _$MarketVehicle {
  factory MarketVehicle({
    required String name,
    required String model,
    required String description,
    @Default(<VehiclePart>[]) List<VehiclePart> parts,
    required double fuelPerPixel,
    required double fuelCapacity,

    /// Max speed in pixels per second
    required int maxSpeed,
    required double maxCargoWeight,
    required int partsToBuild,
    required VehicleType preferredVehicleType,
    required double otherCargoTypeEffience,
    @Default(0) int cost,
    @Default(0) int premiumCost,
  }) = _MarketVehicle;

  const MarketVehicle._();

  factory MarketVehicle.fromJson(Map<String, dynamic> json) =>
      _$MarketVehicleFromJson(json);
}
