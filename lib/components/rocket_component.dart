import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:moonlander/components/line_component.dart';
import 'package:moonlander/game_state.dart';
import 'package:moonlander/main.dart';

class RocketComponent extends SpriteAnimationGroupComponent<_AnimationKey>
    with HasHitboxes, Collidable, HasGameRef<MoonLanderGame> {
  RocketComponent({
    required Vector2 position,
    required Vector2 size,
    required this.joystick,
  }) : super(
          position: position,
          size: size,
        );

  final JoystickComponent joystick;
  double fuel = 100;

  var _joystickDirection = JoystickDirection.idle;
  final _speed = 7;
  final _animationSpeed = .1;
  var _animationTime = 0.0;
  final _velocity = Vector2.zero();
  final _gravity = Vector2(0, 1);
  var _collisionActive = false;

  Vector2 actualSpeed() {
    return _velocity.scaled(_speed.toDouble());
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animations = await _loadAnimation(gameRef);

    current = _AnimationKey.idle;

    addHitbox(HitboxRectangle(relation: Vector2(1, 0.55)));
  }

  void _setAnimationState() {
    current = current?.next(_joystickDirection);
    angle = radians(current?.angle ?? 0);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (joystick.direction != _joystickDirection) {
      _joystickDirection = joystick.direction;
      _animationTime = 0;
    }

    _updateVelocity(dt);
    position.add(_velocity);
    _animationTime += dt;

    if (_animationTime >= _animationSpeed) {
      _setAnimationState();
      _animationTime = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (gameRef.debugMode) {
      debugTextPaint.render(canvas, 'velocity: $_velocity', Vector2(size.x, 0));
    }
  }

  void _updateVelocity(double dt) {
    if (!joystick.delta.isZero()) {
      _velocity.add(joystick.delta.normalized() * _speed.toDouble() * dt);
    }

    _velocity
      ..add(_gravity.normalized() * dt)
      ..clampScalar(-10, 10);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (_collisionActive) {
      return;
    }

    if (other is LineComponent) {
      _lose();
    }

    super.onCollision(intersectionPoints, other);
  }

  void _lose() {
    _velocity.scale(0);
    _collisionActive = true;

    current = _AnimationKey.idle;
    GameState.playState = PlayingState.lost;
    gameRef.pause();
  }
}

Future<Map<_AnimationKey, SpriteAnimation>> _loadAnimation(
    FlameGame game) async {
  const stepTime = .3;
  const frameCount = 2;

  final sheet = SpriteSheet.fromColumnsAndRows(
    image: await game.images.load('ship_spritesheet.png'),
    columns: frameCount,
    rows: 6,
  );

  SpriteAnimation spriteAnimation(int row) => sheet.createAnimation(
        row: row,
        stepTime: stepTime,
      );

  return {
    _AnimationKey.idle: spriteAnimation(0),
    _AnimationKey.up: spriteAnimation(1),
    _AnimationKey.left: spriteAnimation(2),
    _AnimationKey.right: spriteAnimation(3),
    _AnimationKey.farLeft: spriteAnimation(4),
    _AnimationKey.farRight: spriteAnimation(5)
  };
}

class _AnimationKey {
  const _AnimationKey({
    required this.sequencePosition,
    required this.angle,
  });

  final int sequencePosition;
  final double angle;

  static const idle = AnimationKeyIdle();
  static const up = AnimationKeyUp();
  static const left = AnimationKeyLeft();
  static const farLeft = AnimationKeyFarLeft();
  static const right = AnimationKeyRight();
  static const farRight = AnimationKeyFarRight();

  static _AnimationKey? inSequence(
      int position, JoystickDirection newDirection) {
    switch (position) {
      case -2:
        return farLeft;
      case -1:
        return left;
      case 0:
        return newDirection == JoystickDirection.idle ? idle : up;
      case 1:
        return right;
      case 2:
        return farRight;
      default:
        return null;
    }
  }

  _AnimationKey next(JoystickDirection direction) {
    switch (direction) {
      case JoystickDirection.left:
        return inSequence(sequencePosition - 1, direction) ?? farLeft;
      case JoystickDirection.right:
        return inSequence(sequencePosition + 1, direction) ?? farRight;
      default:
        {
          if (sequencePosition == 0) {
            return inSequence(0, direction) ?? up;
          } else {
            return inSequence(
                    sequencePosition +
                        (direction == JoystickDirection.left ? 1 : -1),
                    direction) ??
                up;
          }
        }
    }
  }
}

class AnimationKeyIdle extends _AnimationKey {
  const AnimationKeyIdle()
      : super(
          sequencePosition: 0,
          angle: 0,
        );
}

class AnimationKeyUp extends _AnimationKey {
  const AnimationKeyUp()
      : super(
          sequencePosition: 0,
          angle: 0,
        );
}

class AnimationKeyLeft extends _AnimationKey {
  const AnimationKeyLeft()
      : super(
          sequencePosition: -1,
          angle: -7.5,
        );
}

class AnimationKeyFarLeft extends _AnimationKey {
  const AnimationKeyFarLeft()
      : super(
          sequencePosition: -2,
          angle: -15,
        );
}

class AnimationKeyRight extends _AnimationKey {
  const AnimationKeyRight()
      : super(
          sequencePosition: 1,
          angle: 7.5,
        );
}

class AnimationKeyFarRight extends _AnimationKey {
  const AnimationKeyFarRight()
      : super(
          sequencePosition: 2,
          angle: 15,
        );
}
