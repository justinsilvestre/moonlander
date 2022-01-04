import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

final _buttonSize = Vector2(50, 25);

class PauseButtonComponent extends HudButtonComponent {
  PauseButtonComponent({
    required Vector2 position,
    required EdgeInsets margin,
    required Sprite sprite,
    required VoidCallback onPressed,
    Sprite? downSprite,
  }) : super(
          button: SpriteComponent(
              position: position, sprite: sprite, size: _buttonSize),
          margin: margin,
          onPressed: onPressed,
          buttonDown: SpriteComponent(
              position: position, sprite: downSprite, size: _buttonSize),
        );
}
