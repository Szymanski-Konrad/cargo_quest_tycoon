import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/game_stats.dart';
import '../../features/fuel_stations/bloc/fuel_stations_bloc.dart';
import '../bloc/game_bloc.dart';

class GameStatsBar extends StatelessWidget {
  const GameStatsBar({super.key});
  @override
  Widget build(BuildContext context) {
    final GameStats stats =
        context.select((GameBloc bloc) => bloc.state.gameStats);
    final double fuelLevel = context
        .select((FuelStationsBloc bloc) => bloc.state.primary.currentFuelLevel);
    final double maxFuel = context
        .select((FuelStationsBloc bloc) => bloc.state.primary.fuelCapacity);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade700],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _buildLevelIndicator(stats),
            const SizedBox(width: 16),
            _buildStatItem(
                Icons.attach_money, '${stats.coins}', 'Coins', Colors.amber),
            _buildStatItem(
                Icons.inventory_2, '${stats.crates}', 'Boxes', Colors.blue),
            _buildStatItem(Icons.inventory_2, '${stats.premiumCrates}',
                'Premium', Colors.purple),
            _buildStatItem(
              Icons.local_gas_station,
              '${fuelLevel.toStringAsFixed(0)}/${maxFuel.toInt()}',
              'Fuel',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelIndicator(GameStats stats) {
    return Tooltip(
      message: 'Experience: ${stats.exp}/${stats.expToNextLevel}',
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: stats.exp / stats.expToNextLevel,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              strokeWidth: 3,
            ),
            Center(
              child: Text(
                stats.level.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
