import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:cargo_quest_tycoon/game/bloc/game_bloc.dart';
import 'package:cargo_quest_tycoon/game/game_alert.dart';
import 'package:cargo_quest_tycoon/game/game_vehicle.dart';
import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:collection/collection.dart';

class TransportGame extends FlameGame<TransportWorld> with DragCallbacks {
  TransportGame({
    required this.gameBloc,
    required TransportWorld world,
    required CameraComponent camera,
  }) : super(world: world, camera: camera);

  final GameBloc gameBloc;

  Vector2? targetPosition = Vector2.all(0);
  static const speed = 200.0;

  void showAlert(String message) {
    children.whereType<AlertComponent>().forEach((alert) {
      alert.removeFromParent();
    });
    add(AlertComponent(message: message));
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
