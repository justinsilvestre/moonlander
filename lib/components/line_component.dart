import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:moonlander/main.dart';

import 'map_component.dart';

final _linePaint = Paint()..color = Colors.white;
final _goalPaint = Paint();

Vector2 _convertVector(Vector2 gameSize, Vector2 point) {
  final itemSize = gameSize.clone()..divide(MapComponent.grid);
  return Vector2(
    itemSize.x * point.x,
    gameSize.y - itemSize.y * point.y,
  );
}

class LineComponent extends PositionComponent
    with HasHitboxes, Collidable, HasGameRef<MoonLanderGame> {
  LineComponent(this.startPos, this.endPos, {this.isGoal = false});

  final bool isGoal;
  final Vector2 startPos;
  final Vector2 endPos;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    collidableType = CollidableType.passive;

    addHitbox(HitboxRectangle());
  }

  @override
  void onGameResize(Vector2 gameSize) {
    final startPosition = _convertVector(gameSize, startPos);
    final endPosition = _convertVector(gameSize, endPos);

    position = startPosition;
    angle = atan2(
      endPosition.y - startPosition.y,
      endPosition.x - startPosition.x,
    );
    size = Vector2(endPosition.distanceTo(startPosition), 1);

    super.onGameResize(gameSize);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawLine(
        Offset.zero, size.toOffset(), isGoal ? _goalPaint : _linePaint);
  }
}
