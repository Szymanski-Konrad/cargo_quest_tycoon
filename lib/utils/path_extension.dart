import 'package:cargo_quest_tycoon/game/path_finder.dart';

extension PathCalculation on List<PathTile> {
  double calculatePathLength() {
    double cost = 0;
    for (var i = 0; i < length - 1; i++) {
      final current = this[i];
      final next = this[i + 1];
      final dx = next.position.x - current.position.x;
      final dy = next.position.y - current.position.y;
      cost += dx.abs() + dy.abs();
    }
    return cost;
  }
}
