import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:moonlander/main.dart';

import '../terrain_generator.dart';
import 'line_component.dart';

class MapComponent extends Component with HasGameRef<MoonLanderGame> {
  /// The workable grid sizes.
  static final grid = Vector2(40, 30);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final points = TerrainGenerator(
      size: Vector2(grid.x, grid.y / 3),
    ).generate();

    for (var i = 1; i < points.length; i++) {
      await add(LineComponent(points[i - 1], points[i]));
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    drawGrid(canvas);
  }

  /// If in debug mode draws the grid.
  void drawGrid(Canvas canvas) {
    if (!gameRef.debugMode) {
      return;
    }
    // Size of a single item in the grid.
    final itemSize = gameRef.size.clone()..divide(grid);

    for (var x = 0; x < grid.x; x++) {
      for (var y = 0; y < grid.y; y++) {
        canvas.drawRect(
          Rect.fromLTWH(x * itemSize.x, y * itemSize.y, itemSize.x, itemSize.y),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = Colors.pink
            ..strokeWidth = .1,
        );
      }
    }
  }
}