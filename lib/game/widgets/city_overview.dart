import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cargo.dart';
import '../../data/models/city.dart';
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
    final City? selectedCity = context.select(
      (CitiesBloc bloc) => bloc.state.currentCity,
    );
    final garages = context.select(
      (GarageBloc bloc) => bloc.state.garages,
    );
    print(garages);
    final bool isGarageInCity = context.select(
      (GarageBloc bloc) => bloc.state.isGarageInCity(selectedCity?.id),
    );
    print(isGarageInCity);

    final List<Cargo> cargos = selectedCity?.cargos ?? <Cargo>[];

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.2),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.blue.shade50,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('${selectedCity?.name}'),
                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close),
                      color: Colors.black,
                      iconSize: 40,
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    final String? id = selectedCity?.id;
                    if (id == null) {
                      return;
                    }
                    context
                        .read<CitiesBloc>()
                        .add(RefreshCityCargos(cityId: id));
                  },
                  child: const Text('Refresh'),
                ),
                if (!isGarageInCity)
                  ElevatedButton(
                    child: const Text('Build garage'),
                    onPressed: () {
                      context
                          .read<GarageBloc>()
                          .add(GaragesEventBuildNew(cityId: selectedCity!.id));
                    },
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        for (final Cargo cargo in cargos)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Text(
                                    '${cargo.type.name} - ${cargo.weight.toInt()} kg - ${cargo.coins?.toInt()}\$'),
                                IconButton(
                                  onPressed: () {
                                    final vehicleId = context
                                        .read<GarageBloc>()
                                        .state
                                        .selectedVehicleId;
                                    if (vehicleId == null) {
                                      print('No vehicle selected');
                                      return;
                                    }
                                    context
                                        .read<VehiclesManagementBloc>()
                                        .add(AddCargoToVehicle(
                                          cargo: cargo,
                                          vehicleId: vehicleId,
                                        ));
                                  },
                                  icon: Icon(Icons.get_app),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
