import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '../data/enums/vehicle_status.dart';
import '../data/models/garage.dart';
import '../data/models/map_tile.dart';
import '../data/models/map_tile_position.dart';
import '../data/models/vehicle.dart';
import '../features/cities_management/bloc/cities_bloc.dart';
import '../features/fuel_stations/bloc/fuel_stations_bloc.dart';
import '../features/fuel_stations/bloc/fuel_stations_event.dart';
import '../features/game_alerts/bloc/game_alerts_bloc.dart';
import '../features/game_alerts/bloc/game_alerts_event.dart';
import '../features/garage/garage_bloc.dart';
import '../features/garage/garage_event.dart';
import '../features/garage/garage_state.dart';
import '../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import '../features/vehicles_management/bloc/vehicles_management_event.dart';
import '../utils/map_extension.dart';
import 'bloc/game_bloc.dart';
import 'game_alert.dart';
import 'game_tile.dart';
import 'transport_world.dart';
import 'utils/vector2_extension.dart';

const String vehicleShopOverlay = 'VehicleShop';
const String availableTrucks = 'availableTrucks';
const String cityOverview = 'cityOverview';
const String garageOverview = 'garageOverview';
const String garageCargoOverview = 'garageCargoOverview';

class TransportGame extends FlameGame<TransportWorld> with DragCallbacks {
  TransportGame({
    required this.gameBloc,
    required this.stationsBloc,
    required this.vehiclesBloc,
    required this.citiesBloc,
    required this.garageBloc,
    required this.alertsBloc,
    required TransportWorld world,
    required CameraComponent camera,
  }) : super(world: world, camera: camera);

  final GameBloc gameBloc;
  final FuelStationsBloc stationsBloc;
  final VehiclesManagementBloc vehiclesBloc;
  final CitiesBloc citiesBloc;
  final GarageBloc garageBloc;
  final GameAlertsBloc alertsBloc;

  Vector2? targetPosition = Vector2.all(0);
  static const double speed = 200.0;

  int unlockedTiles = 0;
  int garagesCount = 0;

  void tryToDiscoverTile(GameTile tile) {
    if (!world.tiles
        .isAnyNeighborDiscovered(tile.gridPosition.toMapTilePosition())) {
      alertsBloc.add(const GameAlertNoNeighbourTileDiscovered());
      return;
    }

    final position = tile.gridPosition.toMapTilePosition();
    final translation = world.tiles.translation;
    final mapTile = world.tiles[(position.y - translation.y).toInt()]
        [(position.x - translation.x).toInt()];

    gameBloc.add(UnlockTile(mapTile));
  }

  void truckArrived(Vehicle vehicle) {
    final finishedCargos =
        vehicle.cargos.where((item) => item.sourceId == vehicle.garageId);
    final cargoRevenue = finishedCargos.fold<double>(
      0.0,
      (prev, curr) => prev + (curr.coins ?? 0.0),
    );

    gameBloc.add(GainCoins(cargoRevenue.toInt()));
    alertsBloc.add(GameAlertTruckArrived(vehicle.name));
    alertsBloc.add(GameAlertGainCoins(cargoRevenue.toInt()));
    final vehicleGarageId = vehicle.garageId;
    if (vehicleGarageId != null) {
      final comingCargo = vehicle.cargos
          .where((item) => item.sourceId != vehicleGarageId)
          .toList();

      final cargos = comingCargo
          .map((item) => item.copyWith(sourceId: vehicleGarageId))
          .toList();

      garageBloc.add(
        AddCargoToGarage(
          garageId: vehicleGarageId,
          cargos: cargos,
        ),
      );
    }
    vehiclesBloc.add(UpdateVehicleStatus(vehicle.id, VehicleStatus.idle));
    vehiclesBloc.add(ClearVehicleCargo(vehicleId: vehicle.id));
  }

  void sendTruck(Vehicle vehicle, {bool transportToGarage = true}) {
    if (vehicle.cargos.isEmpty) {
      showAlert('Vehicle has no cargo');
      return;
    }

    final vehicleGarage = garageBloc.state.currentGarage;
    if (vehicleGarage == null) {
      showAlert('Vehicle has no assigned garage');
      return;
    }

    final cargosToGarage = vehicle.cargos
        .where((item) => item.sourceId != vehicleGarage.id)
        .toList();

    final cargosToDestination =
        vehicle.cargos.where((item) => item.sourceId == vehicleGarage.id);

    final cityIds = {
      ...cargosToGarage.map((toElement) => toElement.sourceId),
      ...cargosToDestination.map((toElement) => toElement.targetId),
    }.toList();

    final positions = [
      vehicleGarage.position.toVector2(),
      ...cityIds.map((cityId) => citiesBloc.state.cities
          .firstWhere((city) => city.id == cityId)
          .position
          .toVector2()),
      vehicleGarage.position.toVector2(),
    ];

    if (world.showTruckWithRoute(vehicle, positions)) {
      vehiclesBloc.add(
        UpdateVehicleStatus(
          vehicle.id,
          VehicleStatus.inTransit,
        ),
      );
      for (final cargo in vehicle.cargos) {
        citiesBloc.add(RemoveCargoFromCity(
          cityId: cargo.sourceId,
          cargoId: cargo.id,
        ));
        garageBloc.add(RemoveCargoFromGarage(
          garageId: cargo.sourceId,
          cargoIds: [cargo.id],
        ));
      }
    }
  }

  @override
  FutureOr<void> onLoad() {
    gameBloc.stream.listen((GameState state) {
      if (state.unlockedTiles.length > unlockedTiles) {
        unlockedTiles = state.unlockedTiles.length;
        final worldTiles = world.children.whereType<GameTile>();
        for (final tile in worldTiles) {
          if (tile.isDiscovered) {
            continue;
          }
          if (state.unlockedTiles.any(
              (MapTile item) => item.position.isGridEqual(tile.gridPosition))) {
            tile.isDiscovered = true;
            world.tiles.discoverTile(tile.gridPosition.toMapTilePosition());
          }
        }
      }
    });
    garageBloc.stream.listen((GarageState state) {
      if (state.garages.length > garagesCount) {
        garagesCount = state.garages.length;
        final worldTiles = world.children.whereType<GameTile>();
        for (final tile in worldTiles) {
          if (!tile.isDiscovered) {
            continue;
          }

          if (state.garages.any(
              (Garage item) => item.position.isGridEqual(tile.gridPosition))) {
            tile.hasGarage = true;
            world.tiles.discoverTile(tile.gridPosition.toMapTilePosition());
          }
        }
      }
      if (state.currentGarage != null) {
        garagesCount++;
      }
    });

    return super.onLoad();
  }

  void showAlert(String message) {
    children.whereType<AlertComponent>().forEach((AlertComponent alert) {
      alert.removeFromParent();
    });
    add(AlertComponent(message: message));
  }

  void openCityOverview(Vector2 cityCoords, String cityName) {
    final MapTilePosition cityPosition =
        MapTilePosition(x: cityCoords.x, y: cityCoords.y);

    citiesBloc.add(ChangeCity(cityPosition, cityName));
    overlays.remove(cityOverview);
    overlays.add(cityOverview);
  }

  void openGarageOverview(Vector2 garageCoords) {
    final MapTilePosition garagePosition = MapTilePosition(
      x: garageCoords.x,
      y: garageCoords.y,
    );

    garageBloc.add(ShowGarage(
      garagePosition: garagePosition,
      onNoGarage: () => overlays.remove(cityOverview),
    ));
    citiesBloc.add(const CloseCity());
    overlays.remove(garageOverview);
    overlays.add(garageOverview);
  }

  void closeCityOverview() {
    overlays.remove(cityOverview);
  }

  void closeGarageOverview() {
    overlays.remove(garageOverview);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    Vector2? target = targetPosition;

    if (target != null) {
      target -= event.canvasDelta;
      targetPosition = target;
    } else {
      targetPosition = event.canvasStartPosition;
    }

    super.onDragUpdate(event);
  }

  @override
  void update(double dt) {
    final Vector2? target = targetPosition;
    if (target != null) {
      final Vector2 diff = (target - camera.viewfinder.position).normalized();
      if (diff.length < speed * dt) {
        camera.viewfinder.position = target;
      } else {
        camera.viewfinder.position -= diff.normalized() * speed * dt;
      }
    }

    final fuelRatio = stationsBloc.state.primary.fuelRefillRate * dt;
    final vehicleFuelRatio = stationsBloc.state.primary.vehicleRefillRate * dt;

    stationsBloc.add(FuelStationsEventAddFuel(
      '',
      fuelRatio,
    ));

    final idleTrucks = vehiclesBloc.state.boughtTrucks
        .where((item) => item.status == VehicleStatus.idle);
    for (final truck in idleTrucks) {
      if (stationsBloc.state.primary.currentFuelLevel > vehicleFuelRatio) {
        if (!truck.isFullTank()) {
          vehiclesBloc.add(RefillVehicle(truck.id, vehicleFuelRatio));
          stationsBloc.add(FuelStationsEventRefillVehicle(
            '',
            vehicleFuelRatio,
          ));
        }
      }
    }

    super.update(dt);
  }
}
