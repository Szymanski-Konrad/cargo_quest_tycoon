import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:cargo_quest_tycoon/data/enums/vehicle_part_type.dart';
import 'package:cargo_quest_tycoon/data/enums/vehicle_status.dart';
import 'package:cargo_quest_tycoon/data/enums/vehicle_type.dart';
import 'package:cargo_quest_tycoon/data/models/vehicle_part.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicle.freezed.dart';
part 'vehicle.g.dart';

@freezed
class Vehicle with _$Vehicle {
  const Vehicle._();

  factory Vehicle({
    String? id,
    required String name,
    required String model,
    @Default([]) List<VehiclePart> parts,
    required double fuelPerPixel,
    required int fuelCapacity,
    required double currentFuelLevel,

    /// Max speed in pixels per second
    required int maxSpeed,

    /// Kilograms
    required double maxCargoWeight,
    required int cost,
    double? premiumCost,
    required VehicleType preferredVehicleType,
    required double otherCargoTypeEffience,
    @Default(VehicleStatus.idle) VehicleStatus status,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

  bool hasEnoughFuel(double distance) =>
      currentFuelLevel >= distance * fuelPerPixel;

  double maxDistance() => (currentFuelLevel / fuelPerPixel) / 2;

  Vehicle mountPart(VehiclePart newPart) {
    // Znajdź istniejącą część tego samego typu
    final currentParts = List.of(parts);
    final existingPartIndex =
        currentParts.indexWhere((part) => part.id == newPart.id);
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
    final newFuelCapacity = parts
        .where((part) => part.type == VehiclePartType.tank)
        .fold(fuelCapacity, (prev, part) => prev + part.realValue.toInt());
    final newFuelPerPixel = parts
        .where((part) => part.type == VehiclePartType.wheel)
        .fold(fuelPerPixel, (prev, part) => prev + part.realValue);
    final newMaxCargoWeight = parts
        .where((part) => part.type == VehiclePartType.suspension)
        .fold(maxCargoWeight, (prev, part) => prev + part.realValue);
    final newMaxSpeed = parts
        .where((part) => part.type == VehiclePartType.engine)
        .fold(maxSpeed, (prev, part) => prev + part.realValue.toInt());

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
      default:
        return maxSpeed * 0.1;
    }
  }
}
