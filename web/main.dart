import 'dart:html';

import 'canvas_screen.dart';
import 'game_runner.dart';

void main() {
  CanvasElement canvas = new CanvasElement();
  document.body.children.add(canvas);
  Grid.size = new Size(10, 16);
  Size screen_size = new Size(80, 24);
  Font font = new Font("22px 'courier new'");
  String background_color = "black";
  CanvasScreen screen = new CanvasScreen(canvas, screen_size, font, background_color);
  screen.initialize();
  GameRunner runner = new GameRunner(new WalkDemo(screen));
  runner.run();
}

class WalkDemo implements Game {
  Coordinate _pos;
  CanvasScreen _screen;
  Map<int, Coordinate> _dirs;
  WalkDemo(this._screen) {
    _pos = new Grid(3, 3);
    _dirs = {
      KeyCode.H: Direction.W,
      KeyCode.J: Direction.S,
      KeyCode.K: Direction.N,
      KeyCode.L: Direction.E,
      KeyCode.Y: Direction.NW,
      KeyCode.U: Direction.NE,
      KeyCode.B: Direction.SW,
      KeyCode.N: Direction.SE,
    };
  }

  void key_down(int key) {
    if (_dirs.containsKey(key) == false) return;
    _pos += _dirs[key];
    render();
  }

  void render() {
    _screen.clear();
    _screen.write('@', 'olive', _pos);
  }
}
