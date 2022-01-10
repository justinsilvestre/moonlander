import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class ParticleGenerator {
  static final _random = Random();

  static ParticleComponent createEngineParticle({required Vector2 position}) {
    return ParticleComponent(
      AcceleratedParticle(
        position: position,
        speed: Vector2(
          _random.nextDouble() * 200 - 100,
          -max(_random.nextDouble(), 0.1) * 100,
        ),
        child: CircleParticle(
          radius: 1.0,
          paint: Paint()
            ..color =
                Color.lerp(Colors.yellow, Colors.red, _random.nextDouble())!,
        ),
      ),
    );
  }
}
