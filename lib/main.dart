import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:moonlander/components/pause_button_component.dart';
import 'package:moonlander/widgets/pause_menu_widget.dart';

import 'components/rocket_component.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();

  final game = MoonLanderGame();

  runApp(MaterialApp(
      home: GameWidget(
    game: game,
    initialActiveOverlays: const [],
    loadingBuilder: (context) =>
        const Center(child: CircularProgressIndicator()),
    errorBuilder: (context, ex) {
      debugPrint(ex.toString());
      return const Center(
        child: Text('Sorry, something went wrong. Reload me'),
      );
    },
    overlayBuilderMap: {
      Overlays.pause: (context, MoonLanderGame game) => PauseMenu(
            game: game,
          ),
    },
  )));
}

class MoonLanderGame extends FlameGame
    with
        HasCollidables,
        HasTappables,
        HasKeyboardHandlerComponents,
        HasMoonLanderOverlays {
  @override
  Future<void> onLoad() async {
    add(RocketComponent(
      position: size / 2,
      size: Vector2(32, 48),
      animation: await RocketComponent.loadAnimation(this),
    ));

    add(PauseButtonComponent(
      position: Vector2(0, 0),
      sprite: await Sprite.load('PauseButton.png'),
    ));

    return super.onLoad();
  }
}

class Overlays {
  static const pause = 'pause';
}

mixin HasMoonLanderOverlays on FlameGame {
  void pause() {
    overlays.add(Overlays.pause);
    pauseEngine();
  }

  void resume() {
    overlays.remove(Overlays.pause);
    resumeEngine();
  }

  void restart() {
    throw UnimplementedError('Restart unimplemented');
  }

  void exit() {
    overlays.remove(Overlays.pause);
  }

  bool isPaused() {
    return overlays.isActive(Overlays.pause);
  }

  void togglePaused() {
    if (isPaused()) {
      resume();
    } else {
      pause();
    }
  }
}
