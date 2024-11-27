import 'package:flutter/material.dart';

enum MapTileType {
  road(Colors.blueGrey, true),
  city(Colors.orange, true),
  forest(Colors.green, true),
  mountain(Colors.grey, false),
  water(Colors.blue, false),
  gravel(Colors.brown, true),
  headquarter(Colors.amber, true);

  final Color color;
  final bool isDrivable;

  const MapTileType(this.color, this.isDrivable);
}
