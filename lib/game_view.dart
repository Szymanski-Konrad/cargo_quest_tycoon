import 'package:cargo_quest_tycoon/core/constants/predefined_vehicles.dart';
import 'package:cargo_quest_tycoon/data/models/vehicle.dart';
import 'package:cargo_quest_tycoon/features/fuel_stations/bloc/fuel_stations_bloc.dart';
import 'package:cargo_quest_tycoon/features/vehicles_management/bloc/vehicles_management_bloc.dart';
import 'package:cargo_quest_tycoon/features/vehicles_management/bloc/vehicles_management_event.dart';
import 'package:cargo_quest_tycoon/game/bloc/game_bloc.dart';
import 'package:cargo_quest_tycoon/game/transport_game.dart';
import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:cargo_quest_tycoon/game/widgets/game_stats_bar.dart';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CargoQuestGame extends StatelessWidget {
  const CargoQuestGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GameBloc()),
        BlocProvider(create: (context) => FuelStationsBloc()),
        BlocProvider(create: (context) => VehiclesManagementBloc()),
        BlocProvider(create: (context) => FuelStationsBloc()),
      ],
      child: const GameView(),
    );
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
                final myWorld = TransportWorld();
                return TransportGame(
                  gameBloc: context.read<GameBloc>(),
                  stationsBloc: context.read<FuelStationsBloc>(),
                  world: myWorld,
                  camera: CameraComponent(
                    world: myWorld,
                    viewport: MaxViewport(),
                  ),
                );
              },
              overlayBuilderMap: {
                'VehicleShop': (context, TransportGame game) =>
                    Center(child: VehicleShop(game: game)),
              }),
          const GameStatsBar(),
        ],
      ),
    );
  }
}

class VehicleShop extends StatelessWidget {
  const VehicleShop({
    super.key,
    required this.game,
  });

  final TransportGame game;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 200,
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              game.overlays.remove(vehicleShopOverlay);
            },
            icon: const Icon(Icons.close),
            color: Colors.black,
            iconSize: 40,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: predefinedVehicles
                  .map((vehicle) => ShopVehicleCard(
                        vehicle: vehicle,
                        onTruckBought: () {
                          game.onTruckBought(vehicle);
                          game.overlays.remove(vehicleShopOverlay);
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
    final currentCoins = context.select((GameBloc bloc) => bloc.state.coins);
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
