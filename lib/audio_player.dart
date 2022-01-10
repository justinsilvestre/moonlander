import 'package:flame_audio/flame_audio.dart';
import 'package:moonlander/game_state.dart';

class MoonLanderAudioPlayer {
  Future<void> loadAssets() async {
    await FlameAudio.audioCache.loadAll([
      explosion,
      engine,
    ]);
  }

  static const explosion = 'atari_boom5.mp3';
  static const engine = 'engine.mp3';

  void playExplosion() {
    if (GameState.playSounds) {
      FlameAudio.play(explosion);
    }
  }

  void playEngine() {
    if (GameState.playSounds) {
      FlameAudio.play(engine);
    }
  }
}
