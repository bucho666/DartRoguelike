import 'dart:html';

import 'canvas_screen.dart';
import 'game_runner.dart';

void main() {
  CanvasElement canvas = new CanvasElement();
  document.body.children.add(canvas);
  Size screen_size = new Size(80, 24);
  Font font = new Font("21px 'courier new'", new Size(10, 16));
  String background_color = "black";
  CanvasScreen screen = new CanvasScreen(canvas, screen_size, font, background_color);
  screen.initialize();
  GameRunner runner = new GameRunner(new WalkDemo(screen));
  runner.run();
}

class WalkDemo implements Game {
  Coordinate _pos;
  CanvasScreen _screen;
  WalkDemo(this._screen) {
    _pos = new Coordinate(3, 3);
  }

  void key_down(int key) {
    switch (key) {
      case KeyCode.H:
        _pos.x -= 1;
        break;
      case KeyCode.J:
        _pos.y += 1;
        break;
      case KeyCode.K:
        _pos.y -= 1;
        break;
      case KeyCode.L:
        _pos.x += 1;
        break;
    }
    render();
  }

  void render() {
    _screen.clear();
    _screen.write('@', 'olive', _pos);
  }
}
