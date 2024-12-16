import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flappy_bird_app/components/background%20.dart';
import 'package:flappy_bird_app/components/bird.dart';
import 'package:flappy_bird_app/components/ground.dart';
import 'package:flappy_bird_app/components/pipe_manager.dart';
import 'package:flappy_bird_app/constants.dart';
import 'package:flutter/material.dart';

import '../components/pipe.dart';
import '../components/score.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  late Bird bird;
  late Background background;
  late Ground ground;
  late PipeManager pipeManager;
  late ScoreTest scoreTest;
  late SpriteComponent startScreen;
  bool hasGameStarted = false;

  @override
  FutureOr<void> onLoad() async {
    background = Background(size);
    add(background);

    bird = Bird();
    add(bird);

    ground = Ground();
    add(ground);

    pipeManager = PipeManager();
    scoreTest = ScoreTest();

    startScreen = SpriteComponent(
      sprite: await loadSprite('start_screen.png'),
      position: Vector2(
        size.x / 2,
        size.y / 2,
      ),
      anchor: Anchor.center,
      size: Vector2(300, 400),
      priority: 10,
    );
    add(startScreen);

    bird.velocity = 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!hasGameStarted) {
      bird.velocity = 0;
      bird.position = Vector2(birdStartX, birdStartY);
    }
  }

  @override
  void onTap() {
    if (!hasGameStarted) {
      startGame();
    } else {
      bird.flap();
    }
  }

  void startGame() {
    hasGameStarted = true;
    startScreen.removeFromParent();
    add(pipeManager);
    add(scoreTest);
  }

  int score = 0;
  void incrementScore() {
    score += 1;
  }

  bool isGameOver = false;

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();

    showDialog(
      context: buildContext!,
      builder: (context) => AlertDialog(
        title: Image.asset('assets/images/game_over.png'),
        content: Text(
          "High Score: $score",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }

  void resetGame() {
    bird.position = Vector2(birdStartX, birdStartY);
    bird.velocity = 0;
    score = 0;
    isGameOver = false;
    hasGameStarted = false;

    children.whereType<Pipe>().forEach((pipe) => pipe.removeFromParent());

    pipeManager.removeFromParent();
    scoreTest.removeFromParent();

    add(startScreen);
    resumeEngine();
  }
}
