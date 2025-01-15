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
    @Default(<VehiclePart>[]) List<VehiclePart> parts,
    required double fuelPerPixel,
    required double fuelCapacity,

    /// Max speed in pixels per second
    required int maxSpeed,

    /// Kilograms
    required double maxCargoWeight,
    required int cost,
    double? premiumCost,
    required VehicleType preferredVehicleType,
    required double otherCargoTypeEffience,
  }) = _MarketVehicle;

  const MarketVehicle._();

  factory MarketVehicle.fromJson(Map<String, dynamic> json) =>
      _$MarketVehicleFromJson(json);
}
