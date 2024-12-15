import 'package:uuid/uuid.dart';

import '../../data/models/city.dart';
import '../../data/models/map_tile_position.dart';

final List<City> predefinedCities = <City>[
  City(
    id: const Uuid().v4(),
    position: MapTilePosition(x: 0, y: 0),
    name: 'City 1',
    level: 1,
  ),
  City(
    id: const Uuid().v4(),
    position: MapTilePosition(x: 0, y: 0),
    name: 'City 2',
    level: 1,
  ),
  City(
    id: const Uuid().v4(),
    position: MapTilePosition(x: 0, y: 0),
    name: 'City 3',
    level: 1,
  ),
  City(
    id: const Uuid().v4(),
    position: MapTilePosition(x: 0, y: 0),
    name: 'City 4',
    level: 1,
  ),
  City(
    id: const Uuid().v4(),
    position: MapTilePosition(x: 0, y: 0),
    name: 'City 5',
    level: 1,
  ),
  City(
    id: const Uuid().v4(),
    position: MapTilePosition(x: 0, y: 0),
    name: 'City 6',
    level: 1,
  ),
  City(
    id: const Uuid().v4(),
    position: MapTilePosition(x: 0, y: 0),
    name: 'City 7',
    level: 1,
  ),
];
