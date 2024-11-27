import 'package:cargo_quest_tycoon/features/fuel_stations/bloc/fuel_stations_bloc.dart';
import 'package:cargo_quest_tycoon/game/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameStatsBar extends StatelessWidget {
  const GameStatsBar({super.key});
  @override
  Widget build(BuildContext context) {
    final coins = context.select((GameBloc bloc) => bloc.state.coins);
    final fuelLevel = context
        .select((FuelStationsBloc bloc) => bloc.state.primary.currentFuelLevel);
    final maxFuel = context
        .select((FuelStationsBloc bloc) => bloc.state.primary.fuelCapacity);
    return SafeArea(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Coins: $coins', style: const TextStyle(color: Colors.white)),
            Text('Fuel: ${fuelLevel.toStringAsFixed(0)}/${maxFuel.toInt()}',
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
