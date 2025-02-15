import 'package:flutter/material.dart';

enum GameAlertType {
  gainCoins(Colors.green),
  gainExp(Colors.green),
  spendCoins(Colors.orange),
  truckArrived(Colors.blue),
  notEnoughFuel(Colors.red),
  notEnoughCoins(Colors.red),
  noNeighbourDiscovered(Colors.teal),
  noEnoughSpaceInGarage(Colors.redAccent),
  noEnoughSpaceInVehicle(Colors.redAccent);

  const GameAlertType(this.backgroundColor);
  final Color backgroundColor;
}
