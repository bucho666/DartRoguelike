import 'dart:collection';
import 'dart:html';

import 'canvas_screen.dart';
import 'game_runner.dart';
import 'plane.dart';
import 'stage.dart';

void main() {
  Main.run();
}

class ColorString implements Renderable {
  final String _string;
  final String _color;
  ColorString(this._string, [this._color]);
  void render(CanvasScreen screen, Coordinate pos) {
    screen.write(_string, pos, _color);
  }
}

class ColorText {
  final List<Renderable> _lines;
  ColorText() : _lines = new List<Renderable>();

  void newLine() {
    _lines.add(const NullRenderbleObject());
  }

  void render(CanvasScreen screen, Coordinate pos) {
    Coordinate current = pos;
    for (Renderable line in _lines) {
      line.render(screen, current);
      current = current + Direction.DOWN;
    }
  }

  void write(String string, [String color]) {
    _lines.add(new ColorString(string, color));
  }
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
    Grid.size = new Size(12, 20);
    Size screenSize = new Size(80, 24);
    Font font = new Font("Courier New", 20);
    String backgroundColor = "black";
    CanvasScreen screen = new CanvasScreen(_build_canvas(), screenSize, font, backgroundColor);
    screen.initialize();
    return screen;
  }
}

/// メインシーン
class MainScene extends Scene {
  MainScene() : super() {
    addWindow(new StageWindow(new Grid(1, 1)));
  }
}

/// メッセージウィンドウ
class MessageWindow extends Window {
  String _message;
  MessageWindow(String this._message, Coordinate position)
      : super(position);

  void keyDown(int key) {
    if (key == KeyCode.SPACE) {
      Scene.activeScene.popWindow();
    }
  }
  void render(CanvasScreen screen) {
    screen.write(_message, _position, 'Yellow');
  }
}

class NullRenderbleObject implements Renderable {
  const NullRenderbleObject();
  void render(CanvasScreen screen, Coordinate pos){}
}

/// タイトルウィンドウ
/// TODO TextBoxを作成
/// ..write("string", color)
/// ..write("string")
/// TODO TextWindowを作成
abstract class Renderable {
  void render(CanvasScreen screen, Coordinate pos);
}

/// シーンクラス
class Scene {
  static Scene activeScene;
  final Queue<Window> _windows;
  Scene() : _windows = new Queue<Window>();
  /// Window追加
  void addWindow(Window window) {
    _windows.addLast(window);
  }
  /// 入力処理
  void keyDown(int key) {
    _windows.last.keyDown(key);
  }
  /// Windowを一つ削除
  void popWindow() {
    _windows.removeLast();
  }
  /// 描画処理
  void render(CanvasScreen screen) {
    screen.clear();
    for (Window window in _windows) {
      window.render(screen);
    }
  }
}

/// ステージウィンドウ
class StageWindow extends Window {
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

  final Actor _hero;

  StageWindow(Coordinate position)
      : super(position),
        _hero = new Actor('@', 'olive') {
    final List<String> terrainLines = [
       '##############################',
       '#..................##.....####',
       '#.######..########.##........#',
       '#.#...###.###....#.##.....#..#',
       '#.....#.....#....#.#########.#',
       '#.#...#.....#....#...........#',
       '##############################',];
    Stage.currentStage = buildMap(terrainLines);
    Stage.currentStage.putActor(_hero, const Coordinate(3, 3));
  }
  // TODO ColorTextクラスを実装
  // TODO Windowをクラス化
  // TODO 次にComformボード(はい、いいえ)を選択するメッセージボードを作成
  // TODO はいの場合にレベル移動を実行
  // TODO levels: 各階のマップ定義、構築
  // TODO レベル移動処理(座標はそのままで、current_stageを変更する。
  Stage buildMap(List<String> terrainLines) {
    Size stageSize = new Size(terrainLines[0].length, terrainLines.length);
    Stage stage = new Stage(stageSize);
    for (Coordinate pos in stage.coordinates) {
      stage.setTerrain(terrainLines[pos.y][pos.x], pos);
    }
    return stage;
  }

  void keyDown(int key) {
    if (key == KeyCode.SPACE) {
      Scene.activeScene.addWindow(new MessageWindow("*** test message ***", new Grid(5, 5)));
      return;
    }
    if (_dirs.containsKey(key) == false) return;
    Coordinate current = Stage.currentStage.findActor(_hero);
    Coordinate to = current + _dirs[key];
    if (Stage.currentStage.movable(to) == false) return;
    Stage.currentStage
        ..pickupActor(current)
        ..putActor(_hero, to);
  }

  void render(CanvasScreen screen) {
    Stage.currentStage.render(screen, const Coordinate(2, 2));
  }
}

/// タイトルシーン
class TitleScene extends Scene {
  TitleScene() : super() {
    addWindow(new TitleWindow(new Grid(28, 8)));
  }
}

class TitleWindow extends Window {
  final ColorText _text;
  TitleWindow(Coordinate position)
  : super(position)
  , _text = new ColorText() {
    _text
      ..write("  ********************", "Yellow")
      ..write(" *                    *")
      ..write("*  The RogueLike Game  *")
      ..write(" *                    *")
      ..write("  ********************")
      ..newLine()
      ..write("   (Press Space Key)", 'Silver');
  }

  void keyDown(int key) {
    if (KeyCode.SPACE != key) return;
    Scene.activeScene = new MainScene();
  }

  void render(CanvasScreen screen) {
    _text.render(screen, _position);
  }
}

/// WalkDemo
class WalkDemo implements Game {
  final CanvasScreen _screen;

  WalkDemo(this._screen) {
    Scene.activeScene = new TitleScene();
  }

  void keyDown(int key) {
    Scene.activeScene.keyDown(key);
  }

  void render() {
    Scene.activeScene.render(_screen);
  }
}

/// ウィンドウクラス
abstract class Window {
  Coordinate _position;
  Window(Coordinate this._position);
  /// 入力処理
  void keyDown(int key);
  /// 描画処理
  void render(CanvasScreen screen);
}
