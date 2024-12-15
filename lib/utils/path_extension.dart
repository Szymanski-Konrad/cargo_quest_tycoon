import '../game/path_finder.dart';

extension PathCalculation on List<PathTile> {
  double calculatePathLength() {
    double cost = 0;
    for (int i = 0; i < length - 1; i++) {
      final PathTile current = this[i];
      final PathTile next = this[i + 1];
      final double dx = next.position.x - current.position.x;
      final double dy = next.position.y - current.position.y;
      cost += dx.abs() + dy.abs();
    }
    return cost;
  }
}
