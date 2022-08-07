import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';

void main() {
  runApp(GameWidget(game: FlappyGame()));
}

class FlappyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    final size = Vector2(150, 200);
    final data = SpriteAnimationData.sequenced(
      textureSize: size,
      amount: 4,
      stepTime: 0.2,
    );
    final bird = SpriteAnimationComponent.fromFrameData(
      await images.load('bird.png'),
      data,
    );
    add(bird);
  }

  @override
  void update(double dt) {}
}
