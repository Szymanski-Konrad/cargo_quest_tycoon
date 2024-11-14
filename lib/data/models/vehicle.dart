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
    required double fuelConsumption,
    required double fuelCapacity,
    required double maxSpeed,
    required double maxCargoWeight,
    required double maxPassengers,
    required double cost,
    required double premiumCost,
    required VehicleType preferredVehicleType,
    required double otherCargoTypeEffience,
    @Default(VehicleStatus.idle) VehicleStatus status,
  }) = _Vehicle;

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

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
        .fold(fuelCapacity, (prev, part) => prev + part.realValue);
    final newFuelConsumption = parts
        .where((part) => part.type == VehiclePartType.wheel)
        .fold(fuelConsumption, (prev, part) => prev + part.realValue);
    final newMaxCargoWeight = parts
        .where((part) => part.type == VehiclePartType.suspension)
        .fold(maxCargoWeight, (prev, part) => prev + part.realValue);
    final newMaxSpeed = parts
        .where((part) => part.type == VehiclePartType.engine)
        .fold(maxSpeed, (prev, part) => prev + part.realValue);

    return copyWith(
      fuelCapacity: newFuelCapacity,
      fuelConsumption: newFuelConsumption,
      maxCargoWeight: newMaxCargoWeight,
      maxSpeed: newMaxSpeed,
    );
  }
}
