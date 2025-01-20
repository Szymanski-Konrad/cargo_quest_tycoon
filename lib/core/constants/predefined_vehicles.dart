import '../../data/enums/vehicle_type.dart';
import '../../data/models/market_vehicle.dart';

// TODO(me): Change values for these vehicles, especially the fuelPerPixel

List<MarketVehicle> predefinedVehicles = <MarketVehicle>[
  MarketVehicle(
    name: 'Default',
    model: 'Cheap',
    fuelPerPixel: 8 / 100,
    fuelCapacity: 700,
    maxSpeed: 60,
    maxCargoWeight: 30,
    cost: 500,
    preferredVehicleType: VehicleType.container,
    otherCargoTypeEffience: 0.9,
  ),
  MarketVehicle(
    name: 'Speedster',
    model: 'Fast',
    fuelPerPixel: 15 / 100,
    fuelCapacity: 400,
    maxSpeed: 120,
    maxCargoWeight: 20,
    cost: 2000,
    preferredVehicleType: VehicleType.tanker,
    otherCargoTypeEffience: 0.8,
  ),
  MarketVehicle(
    name: 'Heavy Hauler',
    model: 'Strong',
    fuelPerPixel: 25 / 100,
    fuelCapacity: 1200,
    maxSpeed: 40,
    maxCargoWeight: 60,
    cost: 2500,
    preferredVehicleType: VehicleType.flatbed,
    otherCargoTypeEffience: 0.85,
  ),
  MarketVehicle(
    name: 'Eco Mover',
    model: 'Green',
    fuelPerPixel: 5 / 100,
    fuelCapacity: 600,
    maxSpeed: 70,
    maxCargoWeight: 25,
    cost: 1600,
    preferredVehicleType: VehicleType.container,
    otherCargoTypeEffience: 0.95,
  ),
];
