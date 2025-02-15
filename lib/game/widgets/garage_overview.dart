import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/cargo.dart';
import '../../data/models/garage.dart';
import '../../data/models/map_tile_position.dart';
import '../../data/models/vehicle.dart';
import '../../features/cities_management/bloc/cities_bloc.dart';
import '../../features/garage/garage_bloc.dart';
import '../../features/garage/garage_event.dart';
import '../../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import '../../features/vehicles_management/bloc/vehicles_management_event.dart';
import '../../game_view.dart';
import '../../widgets/cargo_card.dart';

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
      (CitiesBloc bloc) =>
          bloc.state.currentCity != null || bloc.state.lockedCity != null,
    );

    if (selectedGarage == null) {
      return _BuildGarageView(onClose: onClose);
    }

    return _ExistingGarageView(
      garage: selectedGarage,
      isCitySelected: isCitySelected,
      onClose: onClose,
      onSendVehicle: onSendVehicle,
    );
  }
}

class _ExistingGarageView extends StatelessWidget {
  const _ExistingGarageView({
    required this.garage,
    required this.isCitySelected,
    required this.onClose,
    required this.onSendVehicle,
  });

  final Garage garage;
  final bool isCitySelected;
  final VoidCallback onClose;
  final Function(Vehicle) onSendVehicle;

  @override
  Widget build(BuildContext context) {
    final cargoSize = garage.cargos.fold<double>(
      0,
      (previousValue, cargo) => previousValue + cargo.weight,
    );
    final currentVehicleId = context.select(
      (GarageBloc bloc) => bloc.state.selectedVehicleId,
    );

    final vehicle = context.select((VehiclesManagementBloc bloc) =>
        bloc.state.getVehicleById(currentVehicleId));

    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: isCitySelected ? 160 : 300,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(context, cargoSize),
            if (!isCitySelected) ...[
              _buildCargoSection(context, vehicle),
              const Divider(
                color: Colors.grey,
                indent: 32.0,
                endIndent: 32.0,
                thickness: 1.0,
              ),
            ],
            _buildVehicleSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double cargoSize) {
    return Container(
      padding: const EdgeInsets.all(8),
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
            icon: const Icon(Icons.close),
            color: Colors.grey.shade700,
            iconSize: 20,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Vehicles: ${garage.vehicles.length}/${garage.slots}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  'Storage: ${cargoSize.toStringAsFixed(1)}/${garage.storageLimit} kg',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cargoSize > garage.storageLimit
                            ? Colors.red
                            : Colors.grey.shade700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCargoSection(BuildContext context, Vehicle? currentVehicle) {
    return Expanded(
      child: garage.cargos.isEmpty
          ? Center(
              child: Text(
                'No cargo available',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            )
          : ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: garage.cargos
                  .map((cargo) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CargoCard(
                          cargo: cargo,
                          currentVehicle: currentVehicle,
                        ),
                      ))
                  .toList(),
            ),
    );
  }

  Widget _buildVehicleSection(BuildContext context) {
    final availableVehicles = context.select(
      (VehiclesManagementBloc bloc) => bloc.state.boughtTrucks
          .where((vehicle) => !garage.vehicles.contains(vehicle.id))
          .toList(),
    );

    final currentVehicleId = context.select(
      (GarageBloc bloc) => bloc.state.selectedVehicleId,
    );

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: garage.slots,
        itemBuilder: (context, index) {
          if (index >= garage.vehicles.length) {
            return _buildEmptySlot(context, availableVehicles);
          }
          return _buildVehicleSlot(
              context, garage.vehicles[index], currentVehicleId);
        },
      ),
    );
  }

  Widget _buildEmptySlot(
      BuildContext context, List<Vehicle> availableVehicles) {
    return GestureDetector(
      onTap: () {
        if (availableVehicles.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No available vehicles')),
          );
          return;
        }
        showDialog(
          context: context,
          builder: (context) => const NonAssignedVehicles(),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.add, color: Colors.grey.shade400),
      ),
    );
  }

  Widget _buildVehicleSlot(
      BuildContext context, String vehicleId, String? currentVehicleId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: VehicleCard(
        vehicleId: vehicleId,
        isCurrentVehicle: vehicleId == currentVehicleId,
        onSendVehicle: onSendVehicle,
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
        padding: const EdgeInsets.all(4.0),
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: isCurrentVehicle ? Colors.blue.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isCurrentVehicle ? Colors.blue.shade300 : Colors.grey.shade300,
            width: isCurrentVehicle ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVehicleHeader(context, vehicle),
            const SizedBox(height: 4),
            _buildProgressBars(vehicle),
            if (vehicle.cargos.isNotEmpty && vehicle.status.isIdle)
              _buildActionButtons(context, vehicle),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleHeader(BuildContext context, Vehicle vehicle) {
    return Column(
      children: [
        Icon(
          isCurrentVehicle
              ? Icons.local_shipping
              : Icons.local_shipping_outlined,
          color: isCurrentVehicle ? Colors.blue.shade700 : Colors.grey.shade700,
          size: 20.0,
        ),
        Text(
          vehicle.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isCurrentVehicle
                    ? Colors.blue.shade700
                    : Colors.grey.shade700,
              ),
        ),
      ],
    );
  }

  Widget _buildProgressBars(Vehicle vehicle) {
    return Column(
      children: [
        _ProgressBar(
          value: vehicle.currentFuelLevel / vehicle.fuelCapacity,
          color: Colors.orange,
          icon: Icons.local_gas_station,
        ),
        const SizedBox(height: 4),
        _ProgressBar(
          value: vehicle.cargoSize / vehicle.maxCargoWeight,
          color: Colors.green,
          icon: Icons.inventory_2,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, Vehicle vehicle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: Icons.drive_eta,
          onPressed: () => onSendVehicle(vehicle),
          tooltip: 'Send vehicle',
        ),
        _ActionButton(
          icon: Icons.clear_all,
          onPressed: () {
            context
                .read<VehiclesManagementBloc>()
                .add(ClearVehicleCargo(vehicleId: vehicleId));
          },
          tooltip: 'Clear cargo',
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.value,
    required this.color,
    required this.icon,
  });

  final double value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: 16.0,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
        ),
        color: Colors.blue.shade700,
      ),
    );
  }
}

class _BuildGarageView extends StatelessWidget {
  const _BuildGarageView({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final position = context.select(
      (GarageBloc bloc) => bloc.state.tileToBuildGarage,
    );

    return _GarageContainer(
      height: 150,
      child: Row(
        children: [
          _CloseButton(onClose: onClose),
          Expanded(
            child: Center(
              child: _BuildGarageButton(position: position),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _BuildGarageButton extends StatelessWidget {
  const _BuildGarageButton({required this.position});

  final MapTilePosition? position;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: position == null
          ? null
          : () => context.read<GarageBloc>().add(
                GaragesEventBuildNew(
                  garageName: 'Garage',
                  position: position!,
                ),
              ),
      icon: const Icon(Icons.build),
      label: Text(
        'Build Garage (\$10)',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade400,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    );
  }
}

class _GarageContainer extends StatelessWidget {
  const _GarageContainer({
    required this.child,
    required this.height,
  });

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClose,
      icon: const Icon(Icons.close),
      color: Colors.grey.shade700,
      iconSize: 20,
    );
  }
}
