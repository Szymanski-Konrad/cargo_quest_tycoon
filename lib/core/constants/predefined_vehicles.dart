import '../../data/enums/vehicle_type.dart';
import '../../data/models/market_vehicle.dart';

List<MarketVehicle> startersVehicle = <MarketVehicle>[
  MarketVehicle(
    name: 'Cheetah',
    model: 'Light-1',
    description:
        'Swift and nimble. The lightweight champion of quick deliveries!',
    fuelPerPixel: 1 / 100,
    fuelCapacity: 200,
    maxSpeed: 70,
    maxCargoWeight: 6,
    cost: 4000,
    preferredVehicleType: VehicleType.container,
    otherCargoTypeEffience: 1.0,
    partsToBuild: 0,
  ),
  MarketVehicle(
    name: 'Wolf',
    model: 'Pack-1',
    description:
        'The pack leader - balanced in all aspects. Born for any challenge!',
    fuelPerPixel: 8 / 100,
    fuelCapacity: 650,
    maxSpeed: 100,
    maxCargoWeight: 12,
    cost: 6000,
    preferredVehicleType: VehicleType.container,
    otherCargoTypeEffience: 1.0,
    partsToBuild: 0,
  ),
  MarketVehicle(
    name: 'Rhino',
    model: 'Heavy-1',
    description: 'The heavyweight champion. No load too heavy!',
    fuelPerPixel: 20 / 100,
    fuelCapacity: 1000,
    maxSpeed: 40,
    maxCargoWeight: 20,
    cost: 10000,
    preferredVehicleType: VehicleType.container,
    otherCargoTypeEffience: 1.0,
    partsToBuild: 0,
  ),
];
