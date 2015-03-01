import 'dart:html';

import 'canvas_screen.dart';
import 'game_runner.dart';
import 'plane.dart';
import 'stage.dart';

void main() {
  Main.run();
}

/// mainクラス
/// システムを初期化し、ゲームを実行する。
class Main {
  static void run() {
    GameRunner runner = new GameRunner(new WalkDemo(_build_screen()));
    runner.run();
  }

  static CanvasElement _build_canvas() {
    CanvasElement canvas = new CanvasElement();
    document.body.children.add(canvas);
    return canvas;
  }

  static CanvasScreen _build_screen() {
    Grid.size = new Size(10, 16);
    Size screen_size = new Size(80, 24);
    Font font = new Font("22px 'courier new'");
    String backgroundColor = "black";
    CanvasScreen screen = new CanvasScreen(_build_canvas(), screen_size, font, backgroundColor);
    screen.initialize();
    return screen;
  }
}

/// WalkDemo
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
  Actor _hero;
  CanvasScreen _screen;
  WalkDemo(this._screen)
      : _pos = new Grid(3, 3),
        _hero = new Actor('@', 'olive') {
    Stage.current_stage = new Stage(new Size(80, 20));
    Stage.current_stage.putActor(_hero, const Coordinate(3, 3));
  }

  void keyDown(int key) {
    if (_dirs.containsKey(key) == false) return;
    Coordinate current = Stage.current_stage.findActor(_hero);
    Stage.current_stage.pickupActor(current);
    current += _dirs[key];
    Stage.current_stage.putActor(_hero, current);
    render();
  }

  void render() {
    _screen.clear();
    Stage.current_stage.render(_screen);
  }
}
