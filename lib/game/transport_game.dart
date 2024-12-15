import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import '../data/models/city.dart';
import '../data/models/garage.dart';
import '../data/models/map_tile.dart';
import '../data/models/map_tile_position.dart';
import '../data/models/vehicle.dart';
import '../features/cities_management/bloc/cities_bloc.dart';
import '../features/fuel_stations/bloc/fuel_stations_bloc.dart';
import '../features/fuel_stations/bloc/fuel_stations_event.dart';
import '../features/garage/garage_bloc.dart';
import '../features/garage/garage_event.dart';
import '../features/vehicles_management/bloc/vehicles_management_bloc.dart';
import 'bloc/game_bloc.dart';
import 'game_alert.dart';
import 'game_tile.dart';
import 'transport_world.dart';
import 'utils/vector2_extension.dart';

const String vehicleShopOverlay = 'VehicleShop';
const String availableTrucks = 'availableTrucks';
const String cityOverview = 'cityOverview';
const String garageOverview = 'garageOverview';

class TransportGame extends FlameGame<TransportWorld> with DragCallbacks {
  TransportGame({
    required this.gameBloc,
    required this.stationsBloc,
    required this.vehiclesBloc,
    required this.citiesBloc,
    required this.garageBloc,
    required TransportWorld world,
    required CameraComponent camera,
  }) : super(world: world, camera: camera);

  final GameBloc gameBloc;
  final FuelStationsBloc stationsBloc;
  final VehiclesManagementBloc vehiclesBloc;
  final CitiesBloc citiesBloc;
  final GarageBloc garageBloc;

  Vector2? targetPosition = Vector2.all(0);
  static const double speed = 200.0;

  int unlockedTiles = 0;

  void tryToDiscoverTile(Vector2 position) {
    gameBloc.add(
      UnlockTile(
        position.toMapTilePosition(),
        () => citiesBloc.add(
          BuyNewCity(position.toMapTilePosition()),
        ),
      ),
    );
  }

  void sendTruck(Vehicle vehicle) {
    final startCityPosition = citiesBloc.state.cities
        .firstWhere(
          (City city) => city.id == vehicle.cargos.first.sourceId,
        )
        .position
        .toMapSizeVector();
    final endCityPosition = citiesBloc.state.cities
        .firstWhere(
          (City city) => city.id == vehicle.cargos.first.targetId,
        )
        .position
        .toMapSizeVector();

    world.showTruckWithRoute(vehicle, startCityPosition, endCityPosition);
  }

  @override
  FutureOr<void> onLoad() {
    gameBloc.stream.listen((GameState state) {
      if (state.unlockedTiles.length > unlockedTiles) {
        unlockedTiles = state.unlockedTiles.length;
        for (final List<GameTile> row in world.tiles) {
          for (final GameTile tile in row) {
            if (!tile.isDiscovered &&
                state.unlockedTiles.any((MapTile item) =>
                    item.position.isGridEqual(tile.gridPosition))) {
              tile.isDiscovered = true;
            }
          }
        }
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

  void openCityOverview(Vector2 cityCoords) {
    final MapTilePosition cityPosition =
        MapTilePosition(x: cityCoords.x, y: cityCoords.y);
    final City? city = citiesBloc.state.cities.firstWhereOrNull(
      (City element) => element.position == cityPosition,
    );

    if (city != null) {
      citiesBloc.add(ChangeCity(cityPosition));
      overlays.remove(cityOverview);
      overlays.add(cityOverview);
    }
    final Garage? cityGarage = garageBloc.state.getGarageByCity(city?.id);
    if (cityGarage != null) {
      garageBloc.add(ShowGarage(garageId: cityGarage.id));
      overlays.remove(garageOverview);
      overlays.add(garageOverview);
    }
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

    stationsBloc.add(FuelStationsEventAddFuel(
      '',
      stationsBloc.state.primary.fuelRefillRate * dt,
    ));

    super.update(dt);
  }
}
