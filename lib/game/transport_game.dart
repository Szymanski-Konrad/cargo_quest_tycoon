import 'package:cargo_quest_tycoon/core/constants/game_constants.dart';
import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:cargo_quest_tycoon/game/game_vehicle.dart';
import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:collection/collection.dart';

class TransportGame extends FlameGame<TransportWorld>
    with DragCallbacks, TapDetector {
  TransportGame({
    required TransportWorld world,
    required CameraComponent camera,
  }) : super(world: world, camera: camera) {
    // camera.viewport.position = Vector2.all(-GameConstants.mapTileSize);
  }

  Vector2? targetPosition = Vector2.all(0);
  static const speed = 200.0;

  // @override
  // bool containsLocalPoint(Vector2 point) {
  //   print('Tapped point: $point');
  //   final isTrue = point.x >= 0 &&
  //       point.y >= 0 &&
  //       point.x < canvasSize.x &&
  //       point.y < canvasSize.y;
  //   print('Is true: $isTrue');
  //   return true;
  //   return isTrue;
  // }

  @override
  void onTapDown(TapDownInfo info) {
    final componenetsAtPoint =
        componentsAtPoint(info.eventPosition.widget).toList();
    print(
        'Tapped components = ${componenetsAtPoint.map((item) => item.runtimeType).toList()}');
    final gameVehicle = componenetsAtPoint
        .firstWhereOrNull((item) => item is GameVehicle) as GameVehicle?;
    if (gameVehicle != null) {
      print('Tapped area with vehicle');
      // gameVehicle.onTapUp(event);
      super.onTapDown(info);
      return;
    }
    final tappedTile = world.findClosestTile(info.eventPosition.widget);

    if (tappedTile != null && tappedTile.type == MapTileType.city) {
      print('Adding truck');
      world.addTruck(tappedTile.position);
    }
    super.onTapDown(info);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    Vector2? target = targetPosition;

    if (target != null) {
      target -= event.canvasDelta;
      targetPosition = target;
    } else {
      targetPosition = event.canvasStartPosition;
    }

    super.onDragUpdate(event);
  }

  @override
  void update(double dt) {
    final target = targetPosition;
    if (target != null) {
      final diff = (target - camera.viewfinder.position).normalized();
      if (diff.length < speed * dt) {
        camera.viewfinder.position = target;
        // targetPosition = null;
      } else {
        camera.viewfinder.position -= diff.normalized() * speed * dt;
      }
    }
    // if (camera.viewfinder.position.x < 0) {
    //   print('Too low x: ${camera.viewfinder.position.x}');
    //   camera.viewfinder.position.x = 0;
    // }
    // if (camera.viewfinder.position.y < 0) {
    //   print('Too low y');
    //   camera.viewfinder.position.y = 0;
    // }
    // if (camera.viewfinder.position.x > GameConstants.mapXSizePx) {
    //   print('Too high x');
    //   camera.viewfinder.position.x = GameConstants.mapXSizePx;
    // }
    // if (camera.viewfinder.position.y > GameConstants.mapYSizePx) {
    //   print('Too high y');
    //   camera.viewfinder.position.y = GameConstants.mapYSizePx;
    // }
    // camera.viewfinder.position += Vector2(1, 2) * dt;
    // print(camera.viewfinder.position);

    super.update(dt);
  }
}
