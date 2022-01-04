import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

enum RocketMovement {
  left,
  right,
  idle,
}

class RocketState {
  const RocketState(this.index, this.movement, this.angle);

  final int index;
  final RocketMovement movement;
  final double angle;

  static const all = [
    farLeft,
    left,
    idle,
    right,
    farRight,
  ];

  static const farLeft = RocketState(0, RocketMovement.left, -15);
  static const left = RocketState(1, RocketMovement.left, -7.5);
  static const idle = RocketState(2, RocketMovement.idle, 0);
  static const right = RocketState(3, RocketMovement.right, 7.5);
  static const farRight = RocketState(4, RocketMovement.right, 15);

  RocketState move(RocketMovement newMovement) {
    switch (newMovement) {
      case RocketMovement.left:
        return this == farLeft ? farLeft : all[index - 1];
      case RocketMovement.idle:
        return this == idle
            ? idle
            : all[index + (movement == RocketMovement.left ? 1 : -1)];
      case RocketMovement.right:
        return this == farRight ? farRight : all[index + 1];
    }
  }
}

class RocketComponent extends SpriteAnimationGroupComponent<RocketState>
    with HasHitboxes, Collidable, HasGameRef {
  RocketComponent({
    required Vector2 position,
    required Vector2 size,
    required this.joystick,
  }) : super(
          position: position,
          size: size,
        );

  final JoystickComponent joystick;

  var _movement = RocketMovement.idle;
  final _speed = 7;
  final _animationSpeed = .1;
  var _animationTime = 0.0;
  final _velocity = Vector2.zero();
  final _gravity = Vector2(0, 1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animations = await _loadAnimation(gameRef);

    current = RocketState.idle;

    addHitbox(HitboxRectangle());
  }

  void _setAnimationState() {
    current = current?.move(_movement);
    angle = radians(current?.angle ?? 0);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (joystick.direction == JoystickDirection.left &&
        _movement != RocketMovement.left) {
      _movement = RocketMovement.left;
      _animationTime = 0;
    } else if (joystick.direction == JoystickDirection.right &&
        _movement != RocketMovement.right) {
      _movement = RocketMovement.right;
      _animationTime = 0;
    } else if (joystick.direction == JoystickDirection.idle &&
        _movement != RocketMovement.idle) {
      _movement = RocketMovement.idle;
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
}

Future<Map<RocketState, SpriteAnimation>> _loadAnimation(FlameGame game) async {
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

  return {
    RocketState.idle: idle,
    RocketState.left: left,
    RocketState.right: right,
    RocketState.farLeft: farLeft,
    RocketState.farRight: farRight
  };
}
