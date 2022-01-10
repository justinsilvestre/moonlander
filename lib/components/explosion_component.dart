import 'package:flame/components.dart';
import 'package:moonlander/main.dart';

class ExplosionComponent extends SpriteAnimationComponent
    with HasGameRef<MoonLanderGame> {
  ExplosionComponent(
    Vector2 position, {
    double? angle,
  }) : super(
          position: position,
          removeOnFinish: true,
          angle: angle,
        );

  @override
  Future<void>? onLoad() async {
    size = Vector2(128, 80);
    position.sub(Vector2(size.x / 2, size.y / 2));
    animation = await gameRef.loadSpriteAnimation(
        'explosion-3.png',
        SpriteAnimationData.sequenced(
          amount: 10,
          stepTime: 0.1,
          textureSize: Vector2(128, 80),
          loop: false,
        ));
    playing = true;
    gameRef.audioPlayer.playExplosion();

    return super.onLoad();
  }

  @override
  void onRemove() {
    gameRef.lose();
    super.onRemove();
  }
}
