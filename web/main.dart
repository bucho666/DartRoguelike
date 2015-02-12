import 'dart:html';

import 'canvas_screen.dart';
import 'game_runner.dart';

void main() {
  Main.run();
}

class Main {
  static void run() {
    GameRunner runner = new GameRunner(new WalkDemo(build_screen()));
    runner.run();
  }

  static CanvasScreen build_screen() {
    Grid.size = new Size(10, 16);
    Size screen_size = new Size(80, 24);
    Font font = new Font("22px 'courier new'");
    String backgroundColor = "black";
    CanvasScreen screen = new CanvasScreen(build_canvas(), screen_size, font, backgroundColor);
    screen.initialize();
    return screen;
  }

  static CanvasElement build_canvas() {
    CanvasElement canvas = new CanvasElement();
    document.body.children.add(canvas);
    return canvas;
  }
}

class Stage {
  // TODO next
  // ２次元は配列は、内部で一次元配列を持ち、
  // x + y * width で indexを計算してアクセスする
  // array[Coordinate] でアクセスする。
  // operator [](Coordinate) で実装可能
}

class WalkDemo implements Game {
  static final Map<int, Coordinate> _dirs = {
    KeyCode.H: Direction.W,
    KeyCode.J: Direction.S,
    KeyCode.K: Direction.N,
    KeyCode.L: Direction.E,
    KeyCode.Y: Direction.NW,
    KeyCode.U: Direction.NE,
    KeyCode.B: Direction.SW,
    KeyCode.N: Direction.SE,
  };
  Coordinate _pos;
  CanvasScreen _screen;
  WalkDemo(this._screen) : _pos = new Grid(3, 3);

  void keyDown(int key) {
    if (_dirs.containsKey(key) == false) return;
    _pos += _dirs[key];
    render();
  }

  void render() {
    _screen.clear();
    _screen.write('@', 'olive', _pos);
  }
}
