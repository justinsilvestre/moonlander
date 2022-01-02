import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

class RocketComponent extends PositionComponent with HasHitboxes, Collidable {
    RocketComponent({
      required Vector2 position,
      required Vector2 size,
    }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    addHitbox(HitboxRectangle());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    renderHitboxes(canvas, paint: Paint()..color = Colors.white);
  }
}