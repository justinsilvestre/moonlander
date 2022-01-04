import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moonlander/main.dart';

enum RocketState {
  idle,
  left,
  right,
  farLeft,
  farRight,
}

enum RocketMovement {
  left,
  right,
  idle,
}

class RocketComponent extends SpriteAnimationGroupComponent<RocketState>
    with HasHitboxes, Collidable, KeyboardHandler {
  RocketComponent({
    required Vector2 position,
    required Vector2 size,
    required Map<RocketState, SpriteAnimation> animation,
  }) : super(
          position: position,
          size: size,
          animations: animation,
        );

  var _movement = RocketMovement.idle;
  final _speed = 10;
  final _animationSpeed = .1;
  var _animationTime = 0.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    current = RocketState.idle;

    addHitbox(HitboxRectangle());
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      RocketMovement newDirection;
      if (keysPressed.contains(LogicalKeyboardKey.altLeft)) {
        newDirection = RocketMovement.left;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        newDirection = RocketMovement.right;
      } else {
        newDirection = RocketMovement.idle;
      }
      _movement = newDirection;
    }

    return true;
  }

  /// placeholder
  void _setAnimationState() {
    switch (_movement) {
      case RocketMovement.idle:
        if (current != RocketState.idle) {
          if (current == RocketState.farLeft) {
            current = RocketState.left;
          } else if (current == RocketState.farRight) {
            current = RocketState.right;
          } else {
            current = RocketState.idle;
          }
        }
        break;
      case RocketMovement.left:
        if (current != RocketState.farLeft) {
          if (current == RocketState.farRight) {
            current = RocketState.right;
          } else if (current == RocketState.right) {
            current = RocketState.idle;
          } else if (current == RocketState.idle) {
            current = RocketState.left;
          } else {
            current = RocketState.farLeft;
          }
        }
        break;
      case RocketMovement.right:
        if (current != RocketState.farRight) {
          if (current == RocketState.farLeft) {
            current = RocketState.left;
          } else if (current == RocketState.left) {
            current = RocketState.idle;
          } else if (current == RocketState.idle) {
            current = RocketState.right;
          } else {
            current = RocketState.farRight;
          }
        }
        break;
    }
  }

  @override
  void update(double dt) {
    position.y += _speed * dt;
    _animationTime += dt;
    if (_animationTime >= _animationSpeed) {
      _setAnimationState();
      _animationTime = 0;
    }

    super.update(dt);
  }

  static Future<Map<RocketState, SpriteAnimation>> loadAnimation(
      MoonLanderGame game) async {
    const stepTime = .3;
    final textureSize = Vector2(16, 24);
    const frameCount = 2;
    SpriteAnimationData spriteAnimationData() => SpriteAnimationData.sequenced(
        amount: frameCount, stepTime: stepTime, textureSize: textureSize);
    final idle = await game.loadSpriteAnimation(
      'ship_animation_idle.png',
      spriteAnimationData(),
    );
    final left = await game.loadSpriteAnimation(
      'ship_animation_left.png',
      spriteAnimationData(),
    );
    final right = await game.loadSpriteAnimation(
      'ship_animation_right.png',
      spriteAnimationData(),
    );
    final farLeft = await game.loadSpriteAnimation(
      'ship_animation_far_left.png',
      spriteAnimationData(),
    );
    final farRight = await game.loadSpriteAnimation(
      'ship_animation_far_right.png',
      spriteAnimationData(),
    );
    final rocketAnimation = {
      RocketState.idle: idle,
      RocketState.left: left,
      RocketState.right: right,
      RocketState.farLeft: farLeft,
      RocketState.farRight: farRight
    };
    return rocketAnimation;
  }
}
