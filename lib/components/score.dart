import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game.dart';

class ScoreTest extends TextComponent with HasGameRef<FlappyBirdGame> {
  ScoreTest()
      : super(
            text: '0',
            textRenderer: TextPaint(
              style: TextStyle(
                color: Colors.grey.shade900,
                fontSize: 48,
              ),
            ));

  @override
  FutureOr<void> onLoad() {
    position = Vector2(
      (gameRef.size.x - size.x) / 2,
      gameRef.size.y - size.y - 50,
    );
  }

  @override
  void update(double dt) {
    final newText = gameRef.score.toString();
    if (text != newText) {
      text = newText;
    }
  }
}
