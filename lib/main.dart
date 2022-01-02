import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:very_good_analysis/very_good_analysis.dart';

import 'components/rocket_component.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();

  final game = MoonLanderGame();

  runApp(GameWidget(
    game: game,
  ));
}

class MoonLanderGame extends FlameGame with HasCollidables {
  @override
  Future<void> onLoad() async {
    unawaited(add(RocketComponent(position: size / 2, size: Vector2.all(20))));

    return super.onLoad();
  }
}
