import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:moonlander/components/pause_button_component.dart';
import 'package:moonlander/widgets/pause_menu_widget.dart';

import 'audio_player.dart';
import 'components/map_component.dart';
import 'components/rocket_component.dart';
import 'components/rocket_info_component.dart';
import 'fixed_vertical_resolution_viewport.dart';
import 'game_state.dart';

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
    with HasCollidables, HasTappables, HasDraggables, HasMoonLanderOverlays {
  late final MoonLanderAudioPlayer audioPlayer;

  @override
  Future<void> onLoad() async {
    debugMode = true;

    final joystickSpriteSheet = SpriteSheet.fromColumnsAndRows(
      image: await images.load('joystick.png'),
      columns: 6,
      rows: 1,
    );
    final joystick = JoystickComponent(
      knob: SpriteComponent(
          sprite: joystickSpriteSheet.getSpriteById(1), size: Vector2.all(100)),
      background: SpriteComponent(
          sprite: joystickSpriteSheet.getSpriteById(0), size: Vector2.all(150)),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    final rocket = RocketComponent(
      position: size / 2,
      size: Vector2(32, 48),
      joystick: joystick,
    );

    camera.viewport = FixedVerticalResolutionViewport(800);

    audioPlayer = MoonLanderAudioPlayer();
    await audioPlayer.loadAssets();

    add(joystick);

    add(MapComponent());

    add(rocket);

    camera.followComponent(rocket);

    add(PauseButtonComponent(
      position: Vector2.zero(),
      margin: const EdgeInsets.all(5),
      sprite: await Sprite.load('PauseButton.png'),
      downSprite: await Sprite.load('PauseButtonInvert.png'),
      onPressed: togglePaused,
    ));

    add(RocketInfo(rocket));

    return super.onLoad();
  }

  void setCameraWorldBounds(double width, double height) {
    camera.worldBounds = Rect.fromLTWH(0, 0, width, height);
  }

  void lose() {
    GameState.playState = PlayingState.lost;
    pause();
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
