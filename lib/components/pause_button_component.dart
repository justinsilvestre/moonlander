import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:moonlander/main.dart';

final _defaultSize = Vector2(50, 25);

class PauseButtonComponent extends SpriteComponent
    with Tappable, HasGameRef<MoonLanderGame> {
  PauseButtonComponent({
    required Vector2 position,
    required Sprite sprite,
  }) : super(
          position: position,
          size: _defaultSize,
          sprite: sprite,
        );

  @override
  bool onTapDown(TapDownInfo info) {
    gameRef.togglePaused();

    return super.onTapDown(info);
  }
}

