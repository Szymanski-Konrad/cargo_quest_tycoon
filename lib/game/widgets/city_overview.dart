import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cargo.dart';
import '../../data/models/city.dart';
import '../../data/models/garage.dart';
import '../../data/models/vehicle.dart';
import '../../features/cities_management/bloc/cities_bloc.dart';
import '../../features/garage/garage_bloc.dart';
import '../../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import '../../features/vehicles_management/bloc/vehicles_management_event.dart';
import '../../widgets/city_card.dart';

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
          padding: const EdgeInsets.only(bottom: 150),
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
            Expanded(
              child: Text(
                selectedCity.name,
                textAlign: TextAlign.center,
              ),
            ),
            IconButton.filled(
              icon: const Icon(
                Icons.refresh,
              ),
              onPressed: () {
                final id = selectedCity.id;
                context.read<CitiesBloc>().add(RefreshCityCargos(cityId: id));
              },
            ),
          ],
        ),
        Text(selectedCity.id),
        Expanded(
          child: _CargoesListView(cargos: cargos, vehicle: vehicle),
        ),
      ],
    );
  }
}

class _CargoesListView extends StatelessWidget {
  const _CargoesListView({
    super.key,
    required this.cargos,
    required this.vehicle,
  });

  final List<Cargo> cargos;
  final Vehicle? vehicle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
