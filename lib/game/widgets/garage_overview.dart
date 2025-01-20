import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cargo.dart';
import '../../data/models/garage.dart';
import '../../data/models/vehicle.dart';
import '../../features/cities_management/bloc/cities_bloc.dart';
import '../../features/garage/garage_bloc.dart';
import '../../features/garage/garage_event.dart';
import '../../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import '../../features/vehicles_management/bloc/vehicles_management_event.dart';
import '../../game_view.dart';
import '../../widgets/city_card.dart';

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

    final isCitySelected = context.select(
      (CitiesBloc bloc) => bloc.state.currentCity != null,
    );

    if (selectedGarage == null) {
      final position =
          context.select((GarageBloc bloc) => bloc.state.tileToBuildGarage);

      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 150,
          width: double.infinity,
          color: Colors.green.shade200,
          child: Row(
            children: [
              CloseButton(onPressed: onClose),
              Expanded(
                child: Center(
                  child: InkWell(
                    child: const Text(
                      'Build garage here for \$10',
                    ),
                    onTap: () {
                      if (position != null) {
                        context.read<GarageBloc>().add(
                              GaragesEventBuildNew(
                                garageName: 'Garage',
                                position: position,
                              ),
                            );
                      } else {
                        print('Cannot build garage here!');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
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

    final vehicle = context.select((VehiclesManagementBloc bloc) =>
        bloc.state.getVehicleById(currentVehicleId));

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: isCitySelected ? 150 : 300,
        color: Colors.green.shade200,
        child: Column(
          children: <Widget>[
            Row(
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  color: Colors.black,
                  iconSize: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                          'Garage ${selectedGarage.vehicles.length}/${selectedGarage.slots}'),
                      Text(
                          'Storage limit: $cargoSize / ${selectedGarage.storageLimit} kg'),
                      Text('UUID: ${selectedGarage.id}'),
                    ],
                  ),
                ),
              ],
            ),
            if (!isCitySelected) ...[
              Expanded(
                child: selectedGarage.cargos.isEmpty
                    ? const Center(child: Text('No cargos'))
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: selectedGarage.cargos
                            .map((Cargo cargo) => CargoCard(
                                  cargo: cargo,
                                  currentVehicle: vehicle,
                                ))
                            .toList(),
                      ),
              ),
              const Divider(
                color: Colors.black,
                indent: 32.0,
                endIndent: 32.0,
                thickness: 2.0,
              ),
            ],
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectedGarage.slots,
                itemBuilder: (context, index) {
                  if (index >= selectedGarage.vehicles.length) {
                    return GestureDetector(
                      onTap: () {
                        if (availableVehicles.isEmpty) {
                          debugPrint('No available vehicles');
                          return;
                        }

                        showDialog(
                          context: context,
                          builder: (context) => const NonAssignedVehicles(),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: const Icon(Icons.add),
                      ),
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
      onTap: () =>
          context.read<GarageBloc>().add(ChangeVehicle(vehicleId: vehicle.id)),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width * 0.2,
        child: Column(
          children: [
            Icon(
              isCurrentVehicle ? Icons.car_crash : Icons.directions_car,
              color: isCurrentVehicle ? Colors.white : null,
              size: 16.0,
            ),
            Text(
              vehicle.name,
              maxLines: 1,
            ),
            SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: vehicle.currentFuelLevel / vehicle.fuelCapacity,
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: vehicle.cargoSize / vehicle.maxCargoWeight,
              ),
            ),
            if (vehicle.cargos.isNotEmpty && vehicle.status.isIdle)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      // height: 32,
                      child: IconButton(
                        onPressed: () {
                          onSendVehicle(vehicle);
                        },
                        iconSize: 16.0,
                        icon: const Icon(Icons.drive_file_move),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      // height: 32,
                      child: IconButton(
                        onPressed: () {
                          context
                              .read<VehiclesManagementBloc>()
                              .add(ClearVehicleCargo(vehicleId: vehicleId));
                        },
                        iconSize: 16.0,
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
