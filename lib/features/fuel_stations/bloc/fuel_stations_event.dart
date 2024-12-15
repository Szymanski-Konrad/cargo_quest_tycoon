import 'package:equatable/equatable.dart';

abstract class FuelStationsEvent extends Equatable {
  const FuelStationsEvent();

  @override
  List<Object> get props => <Object>[];
}

final class FuelStationsEventUpgrade extends FuelStationsEvent {
  const FuelStationsEventUpgrade(this.id);
  final String id;

  @override
  List<Object> get props => <Object>[id];
}

final class FuelStationsEventRefillVehicle extends FuelStationsEvent {
  const FuelStationsEventRefillVehicle(this.id, this.amount);
  final String id;
  final double amount;

  @override
  List<Object> get props => <Object>[id, amount];
}

final class FuelStationsEventAddFuel extends FuelStationsEvent {
  const FuelStationsEventAddFuel(this.id, this.amount);
  final String id;
  final double amount;

  @override
  List<Object> get props => <Object>[id, amount];
}
