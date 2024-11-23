import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class AlertComponent extends TextComponent with HasGameRef {
  final String message;
  final double duration;
  double _timeAlive = 0;

  AlertComponent({
    required this.message,
    this.duration = 5, // 5 seconds by default
  }) : super(
          text: message,
          priority: 5,
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        );

  @override
  void onMount() {
    super.onMount();
    // Position the alert at the top of the screen
    position = Vector2(
      gameRef.size.x / 2 - size.x / 2, // Center horizontally
      50, // Distance from top
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeAlive += dt;
    if (_timeAlive >= duration) {
      removeFromParent();
    }
  }
}
