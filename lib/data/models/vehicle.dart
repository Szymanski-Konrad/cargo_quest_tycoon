import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/map_tile_type.dart';
import '../enums/vehicle_part_type.dart';
import '../enums/vehicle_status.dart';
import '../enums/vehicle_type.dart';
import 'cargo.dart';
import 'vehicle_part.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

@freezed
class Vehicle with _$Vehicle {
  factory Vehicle({
    String? id,
    required String name,
    required String model,
    @Default(<VehiclePart>[]) List<VehiclePart> parts,
    required double fuelPerPixel,
    required int fuelCapacity,
    required double currentFuelLevel,

    /// Max speed in pixels per second
    required int maxSpeed,

    /// Kilograms
    required double maxCargoWeight,
    required int cost,
    double? premiumCost,
    String? cityAssignedId,
    required VehicleType preferredVehicleType,
    required double otherCargoTypeEffience,
    @Default(VehicleStatus.idle) VehicleStatus status,
    @Default([]) List<Cargo> cargos,
  }) = _Vehicle;
  const Vehicle._();

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

  bool hasEnoughFuel(double distance) =>
      currentFuelLevel >= distance * fuelPerPixel;

  double maxDistance() => (currentFuelLevel / fuelPerPixel) / 2;

  double get cargoSize =>
      cargos.fold(0, (double prev, Cargo cargo) => prev + cargo.weight);

  Vehicle mountPart(VehiclePart newPart) {
    // Znajdź istniejącą część tego samego typu
    final currentParts = List<VehiclePart>.of(parts);
    final int existingPartIndex =
        currentParts.indexWhere((VehiclePart part) => part.id == newPart.id);
    if (existingPartIndex != -1) {
      if (newPart.quality > parts[existingPartIndex].quality) {
        currentParts[existingPartIndex] = newPart;
      }
    } else {
      currentParts.add(newPart);
    }

    return copyWith(parts: currentParts)._upgradeVehicle();
  }

  Vehicle _upgradeVehicle() {
    final int newFuelCapacity = parts
        .where((VehiclePart part) => part.type == VehiclePartType.tank)
        .fold(fuelCapacity,
            (int prev, VehiclePart part) => prev + part.realValue.toInt());
    final double newFuelPerPixel = parts
        .where((VehiclePart part) => part.type == VehiclePartType.wheel)
        .fold(fuelPerPixel,
            (double prev, VehiclePart part) => prev + part.realValue);
    final double newMaxCargoWeight = parts
        .where((VehiclePart part) => part.type == VehiclePartType.suspension)
        .fold(maxCargoWeight,
            (double prev, VehiclePart part) => prev + part.realValue);
    final int newMaxSpeed = parts
        .where((VehiclePart part) => part.type == VehiclePartType.engine)
        .fold(maxSpeed,
            (int prev, VehiclePart part) => prev + part.realValue.toInt());

    return copyWith(
      fuelCapacity: newFuelCapacity,
      fuelPerPixel: newFuelPerPixel,
      maxCargoWeight: newMaxCargoWeight,
      maxSpeed: newMaxSpeed,
    );
  }

  double terrainSpeed(MapTileType type) {
    switch (type) {
      case MapTileType.road:
      case MapTileType.city:
      case MapTileType.headquarter:
        return maxSpeed * 1.0;
      case MapTileType.forest:
        return maxSpeed * 0.8;
      case MapTileType.gravel:
        return maxSpeed * 0.7;
      case MapTileType.mountain:
      case MapTileType.water:
        return maxSpeed * 0.01;
    }
  }
}
