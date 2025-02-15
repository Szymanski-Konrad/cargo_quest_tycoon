import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cargo.dart';
import '../../data/models/city.dart';
import '../../data/models/vehicle.dart';
import '../../features/cities_management/bloc/cities_bloc.dart';
import '../../features/garage/garage_bloc.dart';
import '../../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import '../../widgets/cargo_card.dart';

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

    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: selectedCity == null
            ? const _BuyCityOverview()
            : _CityView(selectedCity: selectedCity, onClose: onClose),
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
      return Center(
        child: Text(
          'Cannot buy this city',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
        ),
      );
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => context
              .read<CitiesBloc>()
              .add(BuyNewCity(lockedCity.position, lockedCity.name)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_city, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Buy ${lockedCity.name}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '\$1',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
        ),
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
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.blue.shade700,
                iconSize: 20,
              ),
              Expanded(
                child: Text(
                  selectedCity.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                color: Colors.blue.shade700,
                iconSize: 20,
                onPressed: () => context
                    .read<CitiesBloc>()
                    .add(RefreshCityCargos(cityId: selectedCity.id)),
              ),
            ],
          ),
        ),
        Expanded(
          child: _CargoesListView(
            cargos: selectedCity.cargos,
            vehicle: vehicle,
          ),
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
