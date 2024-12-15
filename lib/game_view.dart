import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/predefined_vehicles.dart';
import 'data/models/vehicle.dart';
import 'features/cities_management/bloc/cities_bloc.dart';
import 'features/fuel_stations/bloc/fuel_stations_bloc.dart';
import 'features/garage/garage_bloc.dart';
import 'features/vehicles_management/bloc/vehicles_management_bloc.dart';
import 'features/vehicles_management/bloc/vehicles_management_event.dart';
import 'game/bloc/game_bloc.dart';
import 'game/transport_game.dart';
import 'game/transport_world.dart';
import 'game/widgets/city_overview.dart';
import 'game/widgets/game_stats_bar.dart';
import 'game/widgets/garage_overview.dart';

class CargoQuestGame extends StatelessWidget {
  const CargoQuestGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const GameView();
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget.controlled(
            gameFactory: () {
              final TransportWorld myWorld = TransportWorld();
              return TransportGame(
                gameBloc: context.read<GameBloc>(),
                stationsBloc: context.read<FuelStationsBloc>(),
                vehiclesBloc: context.read<VehiclesManagementBloc>(),
                citiesBloc: context.read<CitiesBloc>(),
                garageBloc: context.read<GarageBloc>(),
                world: myWorld,
                camera: CameraComponent(
                  world: myWorld,
                  viewport: MaxViewport(),
                ),
              );
            },
            initialActiveOverlays: const [
              garageOverview,
            ],
            overlayBuilderMap: {
              cityOverview: (BuildContext context, TransportGame game) =>
                  CityOverview(
                    onClose: () => game.overlays.remove(cityOverview),
                  ),
              availableTrucks: (BuildContext context, Object? game) =>
                  Container(),
              garageOverview: (BuildContext context, TransportGame game) =>
                  GarageOverview(
                    onClose: () => game.overlays.remove(garageOverview),
                    onSendVehicle: (Vehicle vehicle) {
                      game.sendTruck(vehicle);
                    },
                  ),
            },
          ),
          const GameStatsBar(),
        ],
      ),
    );
  }
}

class VehicleShop extends StatelessWidget {
  const VehicleShop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 200,
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              // game.overlays.remove(vehicleShopOverlay);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
            color: Colors.black,
            iconSize: 40,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: predefinedVehicles
                  .map((Vehicle vehicle) => ShopVehicleCard(
                        vehicle: vehicle,
                        onTruckBought: () {
                          // Navigator.of(context).pop();
                          // game.onTruckBought(vehicle);
                          // game.overlays.remove(vehicleShopOverlay);
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ShopVehicleCard extends StatelessWidget {
  const ShopVehicleCard({
    super.key,
    required this.vehicle,
    required this.onTruckBought,
  });

  final Vehicle vehicle;
  final VoidCallback onTruckBought;

  @override
  Widget build(BuildContext context) {
    final int currentCoins =
        context.select((GameBloc bloc) => bloc.state.coins);
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Icon(Icons.directions_car),
          Text(vehicle.name),
          Text('Coins: ${vehicle.cost}'),
          Text('Speed: ${vehicle.maxSpeed}'),
          Text('Capacity: ${vehicle.maxCargoWeight}'),
          Text('Fuel: ${vehicle.fuelCapacity}'),
          Text('Consumption: ${vehicle.fuelPerPixel}'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: currentCoins >= vehicle.cost
                ? () {
                    context.read<GameBloc>().add(GainCoins(-vehicle.cost));
                    context
                        .read<VehiclesManagementBloc>()
                        .add(BuyVehicle(vehicle));
                    onTruckBought.call();
                  }
                : null,
            child: const Text('Buy'),
          ),
        ],
      ),
    );
  }
}
