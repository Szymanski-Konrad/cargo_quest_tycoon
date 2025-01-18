import 'package:flutter/material.dart';

enum MapTileType {
  road(Colors.blueGrey, true, 1.0),
  city(Colors.indigo, true, 2.0),
  forest(Colors.green, true, 1.5),
  mountain(Colors.deepOrange, true, 15.0),
  gravel(Colors.brown, true, 5.0),
  headquarter(Colors.amber, true, 3.0),
  farmland(Colors.yellow, true, 4.0),
  desert(Colors.orange, true, 3.0),
  tundra(Colors.lightBlue, true, 10.0),
  savanna(Colors.lightGreen, true, 6.0);

  const MapTileType(this.color, this.isDrivable, this.terrainCost);
  final Color color;
  final bool isDrivable;
  final double terrainCost;
}
