part of 'cities_bloc.dart';

abstract class CitiesEvent extends Equatable {
  const CitiesEvent();

  @override
  List<Object?> get props => [];
}

final class BuyNewCity extends CitiesEvent {
  const BuyNewCity(this.cityPosition, this.cityName);
  final MapTilePosition cityPosition;
  final String cityName;

  @override
  List<Object> get props => [cityPosition, cityName];
}

final class ChangeCity extends CitiesEvent {
  const ChangeCity(this.position, this.cityName);
  final MapTilePosition position;
  final String cityName;

  @override
  List<Object> get props => [position, cityName];
}

final class CloseCity extends CitiesEvent {
  const CloseCity();
}

final class RefreshCityCargos extends CitiesEvent {
  const RefreshCityCargos({required this.cityId});
  final String cityId;

  @override
  List<Object> get props => [cityId];
}

final class RemoveCargoFromCity extends CitiesEvent {
  const RemoveCargoFromCity({required this.cityId, required this.cargoId});
  final String cityId;
  final String cargoId;

  @override
  List<Object> get props => [cityId, cargoId];
}

final class AssignCargoToVehicle extends CitiesEvent {
  const AssignCargoToVehicle({
    required this.cityId,
    required this.cargoId,
    required this.vehicleId,
  });
  final String cityId;
  final String cargoId;
  final String vehicleId;

  @override
  List<Object> get props => [cityId, cargoId, vehicleId];
}

final class UnassignCargoFromVehicle extends CitiesEvent {
  const UnassignCargoFromVehicle({required this.cityId, required this.cargoId});
  final String cityId;
  final String cargoId;

  @override
  List<Object> get props => [cityId, cargoId];
}
