import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/vehicle.dart';
import '../../features/cities_management/bloc/cities_bloc.dart';
import '../../features/fuel_stations/bloc/fuel_stations_bloc.dart';
import '../../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import '../../game_view.dart';
import '../bloc/game_bloc.dart';

class GameStatsBar extends StatelessWidget {
  const GameStatsBar({super.key});
  @override
  Widget build(BuildContext context) {
    final int coins = context.select((GameBloc bloc) => bloc.state.coins);
    final double fuelLevel = context
        .select((FuelStationsBloc bloc) => bloc.state.primary.currentFuelLevel);
    final double maxFuel = context
        .select((FuelStationsBloc bloc) => bloc.state.primary.fuelCapacity);
    final List<Vehicle> boughtVehicles = context
        .select((VehiclesManagementBloc bloc) => bloc.state.boughtTrucks);
    final cities = context.select((CitiesBloc bloc) => bloc.state.cities);
    return SafeArea(
      child: ColoredBox(
        color: Colors.black.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Coins: $coins', style: const TextStyle(color: Colors.white)),
            Text(
              'Vehicles: ${boughtVehicles.length}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Cities: ${cities.length}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 16.0),
            Text('Fuel: ${fuelLevel.toStringAsFixed(0)}/${maxFuel.toInt()}',
                style: const TextStyle(color: Colors.white)),
            PopupMenuButton(itemBuilder: (BuildContext itemBuilder) {
              return <PopupMenuItem>[
                PopupMenuItem(
                  child: const Text('Vehicles'),
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const VehicleShop();
                    },
                  ),
                ),
                const PopupMenuItem(
                  child: Text('Exit'),
                ),
              ];
            }),
          ],
        ),
      ),
    );
  }
}
