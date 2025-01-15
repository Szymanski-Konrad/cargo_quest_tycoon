import '../../data/enums/vehicle_type.dart';
import '../../data/models/market_vehicle.dart';

// TODO(me): Change values for these vehicles, especially the fuelPerPixel

List<MarketVehicle> predefinedVehicles = <MarketVehicle>[
  MarketVehicle(
    name: 'Default',
    model: 'Cheap',
    fuelPerPixel: 7 / 100,
    fuelCapacity: 600,
    maxSpeed: 60,
    maxCargoWeight: 15,
    cost: 500,
    preferredVehicleType: VehicleType.container,
    otherCargoTypeEffience: 0.9,
  ),
  MarketVehicle(
    name: 'Speedster',
    model: 'Fast',
    fuelPerPixel: 12 / 100,
    fuelCapacity: 300,
    maxSpeed: 80,
    maxCargoWeight: 10,
    cost: 1000,
    preferredVehicleType: VehicleType.tanker,
    otherCargoTypeEffience: 0.8,
  ),
  MarketVehicle(
    name: 'Heavy Hauler',
    model: 'Strong',
    fuelPerPixel: 15 / 100,
    fuelCapacity: 1000,
    maxSpeed: 40,
    maxCargoWeight: 30,
    cost: 1500,
    preferredVehicleType: VehicleType.flatbed,
    otherCargoTypeEffience: 0.85,
  ),
  MarketVehicle(
    name: 'Eco Mover',
    model: 'Green',
    fuelPerPixel: 5 / 100,
    fuelCapacity: 400,
    maxSpeed: 70,
    maxCargoWeight: 20,
    cost: 800,
    preferredVehicleType: VehicleType.container,
    otherCargoTypeEffience: 0.95,
  ),
];
