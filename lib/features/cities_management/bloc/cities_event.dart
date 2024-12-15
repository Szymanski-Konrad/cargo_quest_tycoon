part of 'cities_bloc.dart';

abstract class CitiesEvent extends Equatable {
  const CitiesEvent();

  @override
  List<Object> get props => <Object>[];
}

final class BuyNewCity extends CitiesEvent {
  const BuyNewCity(this.cityPosition);
  final MapTilePosition cityPosition;

  @override
  List<Object> get props => <Object>[cityPosition];
}

final class ChangeCity extends CitiesEvent {
  const ChangeCity(this.position);
  final MapTilePosition position;

  @override
  List<Object> get props => <Object>[position];
}

final class CloseCity extends CitiesEvent {
  const CloseCity();
}

final class RefreshCityCargos extends CitiesEvent {
  const RefreshCityCargos({required this.cityId});
  final String cityId;

  @override
  List<Object> get props => <Object>[cityId];
}
