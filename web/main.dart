import 'dart:collection';
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
    Grid.size = new Size(10, 20);
    Size screenSize = new Size(80, 24);
    Font font = new Font("20px 'Courier New'");
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
    screen.write(_message, 'Yellow', _position);
  }
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
    final List<String> terrainLines = ['##############################', '#..................##.....####', '#.######..########.##........#', '#.#...###.###....#.##.....#..#', '#.....#.....#....#.#########.#', '#.#...#.....#....#...........#', '##############################',];
    Stage.currentStage = buildMap(terrainLines);
    Stage.currentStage.putActor(_hero, const Coordinate(3, 3));
  }
  // TODO 次にメッセージボードを作成
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
    // TODO Debug
    if (key == KeyCode.SPACE) {
      Scene.activeScene.addWindow(new MessageWindow("test message", new Grid(5, 5)));
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

/// タイトルウィンドウ
class TitleWindow extends Window {
  TitleWindow(Coordinate position) : super(position);

  void keyDown(int key) {
    if (KeyCode.SPACE != key) return;
    Scene.activeScene = new MainScene();
  }

  void render(CanvasScreen screen) {
    String titleColor = 'Yellow';
    screen.write("  ********************", titleColor, _position);
    screen.write(" *                    *", titleColor, _position + new Grid(0, 1));
    screen.write("*  The RogueLike Game  *", titleColor, _position + new Grid(0, 2));
    screen.write(" *                    *", titleColor, _position + new Grid(0, 3));
    screen.write("  ********************", titleColor, _position + new Grid(0, 4));
    screen.write("   (Press Space Key)", 'Silver', _position + new Grid(0, 6));
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
