import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:moonlander/components/rocket_component.dart';
import 'package:moonlander/main.dart';

class RocketInfo extends PositionComponent with HasGameRef<MoonLanderGame> {
  RocketInfo(this._rocket) : super();

  final RocketComponent _rocket;

  final _textRenderer = TextPaint(
    style: const TextStyle(
      fontSize: 16,
      fontFamily: 'AldotheApache',
      color: Colors.white,
    ),
  );

  var _text = '';

  @override
  Future<void>? onLoad() async {
    _text = 'Fuel: 100 % \n'
        'Vertical speed: -99.00\n'
        'Horizontal speed: -99.00';
    final textSize = _textRenderer.measureText(_text);
    size = textSize;
    positionType = PositionType.viewport;
    position = Vector2(
      gameRef.size.x / 2 - size.x / 2,
      textSize.y / 3,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    final actualSpeed = _rocket.actualSpeed();
    _text = '''
Fuel: ${_formatNumber(_rocket.fuel)} %
Horizontal speed: ${_formatNumber(actualSpeed.x)}
Vertical speed: ${_formatNumber(actualSpeed.y * -1)}
    ''';

    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final pos = Vector2.zero();
    _text.split('\n').forEach((line) {
      _textRenderer.render(canvas, line, pos);
      pos.y += size.y / 3;
    });
    super.render(canvas);
  }
}

String _formatNumber(num number) {
  return number.toStringAsFixed(2);
}
