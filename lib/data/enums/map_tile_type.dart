import 'package:flutter/material.dart';

enum MapTileType {
  road(Colors.black),
  city(Colors.orange),
  port(Colors.brown),
  forest(Colors.green),
  mountain(Colors.grey),
  water(Colors.blue),
  empty(Colors.white),
  headquarter(Colors.amber);

  final Color color;

  const MapTileType(this.color);
}
