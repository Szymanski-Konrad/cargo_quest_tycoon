import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cargo.dart';
import '../../data/models/city.dart';
import '../../data/models/vehicle.dart';
import '../../features/cities_management/bloc/cities_bloc.dart';
import '../../features/garage/garage_bloc.dart';
import '../../features/garage/garage_event.dart';
import '../../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import '../../features/vehicles_management/bloc/vehicles_management_event.dart';

class CityOverview extends StatelessWidget {
  const CityOverview({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final City? selectedCity =
        context.select((CitiesBloc bloc) => bloc.state.currentCity);

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 200),
          child: Container(
            width: double.infinity,
            height: 150,
            color: Colors.blue.shade50,
            child: selectedCity == null
                ? const _BuyCityOverview()
                : _CityView(selectedCity: selectedCity, onClose: onClose),
          ),
        ),
      ),
    );
  }
}

class _BuyCityOverview extends StatelessWidget {
  const _BuyCityOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final lockedCity =
        context.select((CitiesBloc bloc) => bloc.state.lockedCity);

    if (lockedCity == null) {
      return const Center(
        child: Text('Cannot buy this city'),
      );
    }

    return Center(
      child: InkWell(
        onTap: () {
          context
              .read<CitiesBloc>()
              .add(BuyNewCity(lockedCity.position, lockedCity.name));
        },
        splashColor: Colors.blue,
        child: Text('Buy ${lockedCity.name} for \$1'),
      ),
    );
  }
}

class _CityView extends StatelessWidget {
  const _CityView({
    super.key,
    required this.selectedCity,
    required this.onClose,
  });

  final City selectedCity;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final vehicleId =
        context.select((GarageBloc bloc) => bloc.state.selectedVehicleId);
    final vehicle = context.select(
        (VehiclesManagementBloc bloc) => bloc.state.getVehicleById(vehicleId));

    final List<Cargo> cargos = selectedCity.cargos;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              color: Colors.black,
              iconSize: 40,
            ),
            Text(selectedCity.name),
            IconButton.filled(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                final id = selectedCity.id;
                context.read<CitiesBloc>().add(RefreshCityCargos(cityId: id));
              },
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                for (final Cargo cargo in cargos)
                  CargoCard(
                    cargo: cargo,
                    currentVehicle: vehicle,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

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
    final vehicle = currentVehicle;
    final vehicleId = vehicle?.id;

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
      child: Row(
        children: [
          Column(
            children: [
              Text(targetCity.name),
              Text(cargo.type.name),
              Text('${cargo.weight.toInt()} kg - ${cargo.coins?.toInt()}\$'),
            ],
          ),
          IconButton(
            onPressed: cargo.vehicleId != null && cargo.vehicleId != vehicleId
                ? null
                : () {
                    if (vehicleId == null || vehicle == null) {
                      return;
                    }

                    if (cargo.vehicleId == vehicleId) {
                      context
                          .read<VehiclesManagementBloc>()
                          .add(RemoveCargoFromVehicle(
                            vehicleId: vehicleId,
                            cargo: cargo,
                          ));
                      context.read<CitiesBloc>().add(
                            UnassignCargoFromVehicle(
                              cityId: cargo.sourceId,
                              cargoId: cargo.id,
                            ),
                          );
                    } else {
                      if (vehicle.maxCargoWeight <
                          vehicle.cargoSize + cargo.weight) {
                        debugPrint('The cargo is too heavy');
                        return;
                      }
                      context
                          .read<VehiclesManagementBloc>()
                          .add(AddCargoToVehicle(
                            cargo: cargo,
                            vehicleId: vehicleId,
                          ));
                      context.read<CitiesBloc>().add(
                            AssignCargoToVehicle(
                              cityId: cargo.sourceId,
                              cargoId: cargo.id,
                              vehicleId: vehicleId,
                            ),
                          );
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
