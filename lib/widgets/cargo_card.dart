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

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: cargo.vehicleId != null && cargo.vehicleId != vehicleId
                ? Colors.red.withOpacity(0.6)
                : Colors.green.withOpacity(0.6),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              targetCity.name,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildWeightValue(context, cargo),
                const SizedBox(width: 8),
                _buildCargoValue(context, cargo),
              ],
            ),
            Center(
              child: IconButton(
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
                icon: Icon(
                  cargo.vehicleId == vehicleId
                      ? Icons.remove_circle
                      : Icons.add_box_rounded,
                  color:
                      cargo.vehicleId == vehicleId ? Colors.red : Colors.green,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightValue(BuildContext context, Cargo cargo) {
    return Row(
      children: [
        Text(
          '${cargo.weight.toInt()}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Icon(
          Icons.scale,
          size: 16,
          color: Colors.black,
        ),
      ],
    );
  }

  Widget _buildCargoValue(BuildContext context, Cargo cargo) {
    if (cargo.coins != null) {
      return Row(
        children: [
          const Icon(
            Icons.attach_money,
            size: 20,
            color: Colors.amber,
          ),
          Text(
            '${cargo.coins?.toInt()}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.amber.shade700,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      );
    }

    if (cargo.standardCrate != null) {
      return const Icon(Icons.inventory_2, size: 20, color: Colors.blue);
    }

    if (cargo.premiumCrate != null) {
      return const Icon(Icons.inventory_2, size: 20, color: Colors.purple);
    }

    return const SizedBox.shrink();
  }
}
