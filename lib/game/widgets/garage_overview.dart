import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cargo.dart';
import '../../data/models/garage.dart';
import '../../data/models/vehicle.dart';
import '../../features/garage/garage_bloc.dart';
import '../../features/garage/garage_event.dart';
import '../../features/vehicles_management/bloc/vehicles_management_bloc.dart';

class GarageOverview extends StatelessWidget {
  const GarageOverview({
    super.key,
    required this.onClose,
    required this.onSendVehicle,
  });

  final VoidCallback onClose;
  final Function(Vehicle) onSendVehicle;

  @override
  Widget build(BuildContext context) {
    final Garage? selectedGarage = context.select(
      (GarageBloc bloc) => bloc.state.currentGarage,
    );

    if (selectedGarage == null) {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: double.infinity,
          color: Colors.green.shade200,
          child: const Text('Please build garage firstly'),
        ),
      );
    }

    final List<Vehicle> availableVehicles = context.select(
      (VehiclesManagementBloc bloc) => bloc.state.boughtTrucks
          .where((Vehicle vehicle) =>
              !selectedGarage.vehicles.contains(vehicle.id))
          .toList(),
    );

    final double cargoSize = selectedGarage.cargos.fold<double>(
      0,
      (double previousValue, Cargo element) => previousValue + element.weight,
    );

    final currentVehicleId = context.select(
      (GarageBloc bloc) => bloc.state.selectedVehicleId,
    );

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        color: Colors.green.shade200,
        child: Column(
          children: <Widget>[
            Text(
                'Garage ${selectedGarage.vehicles.length}/${selectedGarage.slots}'),
            Text('Left vehicles: ${availableVehicles.length}'),
            Text(
                'Storage limit: $cargoSize / ${selectedGarage.storageLimit} kg'),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedGarage.slots,
                itemBuilder: (context, index) {
                  if (index >= selectedGarage.vehicles.length) {
                    return GestureDetector(
                      onTap: () {
                        if (availableVehicles.isEmpty) {
                          print('No available vehicles');
                          return;
                        }
                        final String? vehicleId = availableVehicles.first.id;
                        if (vehicleId != null) {
                          context.read<GarageBloc>().add(
                                AssignVehicleToGarage(
                                  garageId: selectedGarage.id,
                                  vehicleId: vehicleId,
                                ),
                              );
                        }
                      },
                      child: const Icon(Icons.add),
                    );
                  }

                  final String vehicleId = selectedGarage.vehicles[index];

                  return VehicleCard(
                    vehicleId: vehicleId,
                    isCurrentVehicle: vehicleId == currentVehicleId,
                    onSendVehicle: onSendVehicle,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  const VehicleCard({
    super.key,
    required this.vehicleId,
    required this.isCurrentVehicle,
    required this.onSendVehicle,
  });

  final String vehicleId;
  final bool isCurrentVehicle;
  final Function(Vehicle) onSendVehicle;

  @override
  Widget build(BuildContext context) {
    final Vehicle vehicle = context.select(
      (VehiclesManagementBloc bloc) => bloc.state.boughtTrucks.firstWhere(
        (Vehicle vehicle) => vehicle.id == vehicleId,
      ),
    );

    return GestureDetector(
      onTap: () => context.read<GarageBloc>().add(
            ChangeVehicle(vehicleId: vehicle.id ?? ''),
          ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              Icons.directions_car,
              color: isCurrentVehicle ? Colors.white : null,
            ),
            Text(vehicle.name),
            SizedBox(
              width: 50,
              height: 5,
              child: LinearProgressIndicator(
                value: vehicle.currentFuelLevel / vehicle.fuelCapacity,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 50,
              height: 5,
              child: LinearProgressIndicator(
                value: vehicle.cargoSize / vehicle.maxCargoWeight,
              ),
            ),
            if (vehicle.cargos.isNotEmpty)
              SizedBox(
                height: 20,
                child: IconButton(
                  onPressed: () {
                    onSendVehicle(vehicle);
                  },
                  iconSize: 20.0,
                  icon: Icon(Icons.drive_file_move),
                ),
              )
          ],
        ),
      ),
    );
  }
}
