import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';

void main() {
  runApp(GameWidget(game: FlappyGame()));
}

class FlappyGame extends FlameGame
    with HasTappableComponents, DoubleTapDetector {
  SpriteComponent bird = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteAnimationComponent birdAnime = SpriteAnimationComponent();
  String direction = 'down';
  bool running = false;
  int startEnable = 0;
  TextPaint textPaint =
      TextPaint(style: TextStyle(color: Colors.white, fontSize: 40));
  double velocityY = 0;

  @override
  Future<void> onLoad() async {
    print('loading');
    bird
      ..sprite = await loadSprite('birds.png')
      ..size = Vector2(50, 50);
    // add(bird);
    background
      ..sprite = await loadSprite('background.png')
      ..size = size;
    add(background);

    var spritesheet = await images.load('birds.png');
    final spriteSize = Vector2(50 * 1.2, 50 * 1.2);
    SpriteAnimationData data = SpriteAnimationData.sequenced(
        amount: 4, stepTime: 0.09, textureSize: Vector2(720, 720));
    birdAnime = SpriteAnimationComponent.fromFrameData(spritesheet, data)
      ..x = 100
      ..y = 50
      ..size = spriteSize;
    add(birdAnime);
  }

  @override
  void update(double dt) {
    switch (direction) {
      case 'forward':
        birdAnime.x += 1;
        break;
      case 'backward':
        birdAnime.x -= 1;
        break;
      case 'up':
        birdAnime.y -= 3;
        break;
      case 'down':
        birdAnime.y += 3;
        break;
    }
    if (velocityY < 0.1) {
      velocityY += 0.6;
      birdAnime.y += velocityY;
    }
    if (running == true) {
      startEnable = 3;
    }
    if (running == true && birdAnime.y < 10) {
      direction = 'down';
    }
    if (running == true && birdAnime.y > 600) {
      startEnable = 1;
      pauseEngine();
    } else if (running == false) {
      startEnable = 0;
      birdAnime.x = size[0] * 0.37;
      birdAnime.y = size[1] * 0.35;
      pauseEngine();
    }
    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (running == true) {
      startEnable = 3;
      velocityY = -20;
    }
    if (running == false) {
      running = true;
      startEnable = 0;
      birdAnime.y -= 100;
      resumeEngine();
    }
  }

  @override
  void onDoubleTapDown(TapDownInfo info) {
    if (paused) {
      resumeEngine();
      birdAnime.y = 100;
    }

    super.onDoubleTapDown(info);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    switch (startEnable) {
      case 0:
        textPaint.render(
            canvas, 'Tap to Play', Vector2(size[0] * 0.25, size[1] * 0.25));
        break;
      case 1:
        textPaint.render(
            canvas, "Game Over", Vector2(size[0] * 0.25, size[1] * 0.25));
        break;
      case 3:
        textPaint.render(canvas, "", Vector2(0, 0));
        break;
    }
  }
}
