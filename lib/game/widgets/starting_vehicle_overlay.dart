import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/predefined_vehicles.dart';
import '../../data/models/market_vehicle.dart';
import '../../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import '../../features/vehicles_management/bloc/vehicles_management_event.dart';

class StarterVehiclesOverlay extends StatelessWidget {
  const StarterVehiclesOverlay({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 64.0,
        bottom: 32,
        left: 16,
        right: 16,
      ),
      child: Card(
        child: Column(
          children: [
            const Text(
              'Choose your starter vehicle',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...startersVehicle.map((item) => Expanded(
                  child: StarterVehicleCard(
                    vehicle: item,
                    description: item.description,
                    onClose: onClose,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class StarterVehicleCard extends StatelessWidget {
  const StarterVehicleCard({
    super.key,
    required this.vehicle,
    required this.description,
    required this.onClose,
  });

  final MarketVehicle vehicle;
  final String description;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.directions_car, size: 40),
                  const SizedBox(width: 10),
                  Text(
                    vehicle.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        context
                            .read<VehiclesManagementBloc>()
                            .add(BuyVehicle(vehicle));
                        onClose();
                      },
                      child: const Text('Select'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Speed: ${vehicle.maxSpeed} km/h',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Capacity: ${vehicle.maxCargoWeight} kg',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Fuel: ${vehicle.fuelCapacity} L',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                'Comsumption: ${vehicle.fuelPerPixel * 100} l/100km',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
