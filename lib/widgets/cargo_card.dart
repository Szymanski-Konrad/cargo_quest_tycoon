import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/enums/vehicle_status.dart';
import '../data/models/cargo.dart';
import '../data/models/city.dart';
import '../data/models/vehicle.dart';
import '../features/cities_management/bloc/cities_bloc.dart';
import '../features/game_alerts/bloc/game_alerts_bloc.dart';
import '../features/game_alerts/bloc/game_alerts_event.dart';
import '../features/garage/garage_bloc.dart';
import '../features/garage/garage_event.dart';
import '../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import '../features/vehicles_management/bloc/vehicles_management_event.dart';

class CargoCard extends StatelessWidget {
  const CargoCard({
    super.key,
    required this.cargo,
    required this.currentVehicle,
  });

  final Cargo cargo;

  final Vehicle? currentVehicle;

  @override
  Widget build(BuildContext context) {
    final targetCity = context.select(
      (CitiesBloc bloc) => bloc.state.cities.firstWhere(
        (City city) => city.id == cargo.targetId,
      ),
    );
    final isCitySelected = context.select(
      (CitiesBloc bloc) => bloc.state.currentCity != null,
    );
    final vehicle = currentVehicle;
    final vehicleId = vehicle?.id;
    final vehicleGarageId = vehicle?.garageId;
    final vehicleGarage = context
        .select((GarageBloc bloc) => bloc.state.garageById(vehicleGarageId));

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: cargo.vehicleId != null && cargo.vehicleId != vehicleId
              ? Colors.red
              : Colors.green,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Text(
            targetCity.name,
            overflow: TextOverflow.ellipsis,
          ),
          // Text(cargo.type.name),
          Text('${cargo.weight.toInt()} - ${cargo.coins?.toInt()}'),
          IconButton(
            onPressed: vehicle?.status == VehicleStatus.inTransit ||
                    cargo.vehicleId != null && cargo.vehicleId != vehicleId
                ? null
                : () {
                    if (vehicleId == null ||
                        vehicle == null ||
                        vehicleGarageId == null ||
                        vehicleGarage == null) {
                      return;
                    }

                    if (cargo.vehicleId == vehicleId) {
                      context
                          .read<VehiclesManagementBloc>()
                          .add(RemoveCargoFromVehicle(
                            vehicleId: vehicleId,
                            cargo: cargo,
                          ));
                      if (isCitySelected) {
                        context.read<CitiesBloc>().add(
                              UnassignCargoFromVehicle(
                                cityId: cargo.sourceId,
                                cargoId: cargo.id,
                              ),
                            );
                      } else {
                        context.read<GarageBloc>().add(
                              UnassignGarageCargoFromVehicle(
                                garageId: vehicleGarageId,
                                cargoId: cargo.id,
                              ),
                            );
                      }
                    } else {
                      if (vehicle.maxCargoWeight <
                          vehicle.cargoSize + cargo.weight) {
                        context.read<GameAlertsBloc>().add(
                              const GameAlertNoEnoughSpaceInVehicle(),
                            );
                        return;
                      }
                      if (cargo.sourceId != vehicleGarage.id &&
                          vehicleGarage.usedStorage +
                                  vehicle.cargoSize +
                                  cargo.weight >
                              vehicleGarage.storageLimit) {
                        context.read<GameAlertsBloc>().add(
                              const GameAlertNoEnoughSpaceInGarage(),
                            );
                        return;
                      }
                      context
                          .read<VehiclesManagementBloc>()
                          .add(AddCargoToVehicle(
                            cargo: cargo,
                            vehicleId: vehicleId,
                            garageId: vehicleGarageId,
                          ));
                      if (isCitySelected) {
                        context.read<CitiesBloc>().add(
                              AssignCargoToVehicle(
                                cityId: cargo.sourceId,
                                cargoId: cargo.id,
                                vehicleId: vehicleId,
                              ),
                            );
                      } else {
                        context.read<GarageBloc>().add(
                              AssignGarageCargoToVehicle(
                                garageId: cargo.sourceId,
                                cargoId: cargo.id,
                                vehicleId: vehicleId,
                              ),
                            );
                      }
                    }
                  },
            icon: cargo.vehicleId == vehicleId
                ? const Icon(Icons.u_turn_left)
                : const Icon(Icons.get_app),
          ),
        ],
      ),
    );
  }
}
