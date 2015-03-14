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
  /// 実行
  static void run() {
    GameRunner runner = new GameRunner(new WalkDemo(_build_screen()));
    runner.run();
  }
  /// 画面を作成する。
  static CanvasScreen _build_screen() {
    Grid.size = new Size(12, 20);
    Size screenSize = new Size(80, 24);
    Font font = new Font("Courier New", 20);
    String backgroundColor = "black";
    CanvasScreen screen = new CanvasScreen(_build_canvas(), screenSize, font, backgroundColor);
    screen.initialize();
    return screen;
  }
  /// キャンバスを作成する。
  static CanvasElement _build_canvas() {
    CanvasElement canvas = new CanvasElement();
    document.body.children.add(canvas);
    return canvas;
  }
}

/// WalkDemo
class WalkDemo implements Game {
  final CanvasScreen _screen;
  WalkDemo(this._screen) {
    Scene.activeScene = new TitleScene();
  }
  /// 入力処理
  void keyDown(int key) {
    Scene.activeScene.keyDown(key);
  }
  /// 描画処理
  void render() {
    Scene.activeScene.render(_screen);
  }
}

/// タイトルシーン
class TitleScene extends Scene {
  TitleScene() : super() {
    addWindow(new TitleWindow(new Grid(28, 8)));
  }
}

/// タイトルウィンドウ
class TitleWindow extends MessageWindow {
  TitleWindow(Coordinate position)
  : super(position, 'Green') {
    this
      ..write("  ********************", "Yellow")
      ..write(" *                    *")
      ..write("*  The RogueLike Game  *")
      ..write(" *                    *")
      ..write("  ********************")
      ..newLine()
      ..write("   (Press Space Key)", 'Silver');
  }
  /// 入力処理
  void keyDown(int key) {
    if (KeyCode.SPACE != key) return;
    Scene.activeScene = new MainScene();
  }
}

/// メッセージウィンドウ
class MessageWindow extends Window {
  ColorText _messages;
  final String _frameColor;
  MessageWindow(Coordinate position, [this._frameColor="White"])
      : super(position)
      , _messages = new ColorText();
  /// 空行追加
  void newLine() {
    _messages.newLine();
  }
  /// 行追加
  void write(String string, [String color]) {
    _messages.write(string, color);
  }
  /// 入力処理
  void keyDown(int key) {
    if (key != KeyCode.SPACE) return;
    Scene.activeScene.popWindow();
  }
  /// 描画処理
  void render(CanvasScreen screen) {
    Frame frame = new Frame(_messages.size, _frameColor);
    frame.render(screen, _position + Direction.upperLeft);
    _messages.render(screen, _position);
  }
}

class Frame implements Renderable {
  ColorText _frame;
  String _color;
  Size _size;
  String _corner;
  Frame(this._size, [this._color = 'White', this._corner = '*']): _frame = new ColorText();
  set size(Size new_size) => _size = new_size;
  void render(CanvasScreen screen, Coordinate position) {
    screen.color = _color;
    _drawHorizontalLine();
    for (int y = 0; y < _size.height; y++) {
      _drawVerticalLine();
    }
    _drawHorizontalLine();
    _frame.render(screen, position);
  }
  /// 横線作成
  void _drawHorizontalLine() {
    _frame.write('$_corner${"-" * _size.width}$_corner');
  }
  /// 縦線作成
  void _drawVerticalLine() {
    _frame.write('|${" " * _size.width}|');
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

/// 色付き文字列
class ColorString implements Renderable {
  final String _string;
  final String _color;
  ColorString(this._string, [this._color]);
  void render(CanvasScreen screen, Coordinate pos) {
    screen.write(_string, pos, _color);
  }
}

/// テキスト
class ColorText {
  final List<Renderable> _lines;
  int _width;
  ColorText()
  : _lines = new List<Renderable>()
  , _width = 0;
  /// サイズ
  Size get size => new Size(_width, _lines.length);
  /// 空行追加
  void newLine() {
    _lines.add(const NullRenderbleObject());
  }
  /// 描画
  void render(CanvasScreen screen, Coordinate pos) {
    Coordinate current = pos;
    for (Renderable line in _lines) {
      line.render(screen, current);
      current = current + Direction.lower;
    }
  }
  /// 行追加
  void write(String string, [String color]) {
    _lines.add(new ColorString(string, color));
    if (_width >= string.length) return;
    _width = string.length;
  }
}

/// NULL描画オブジェクト
class NullRenderbleObject implements Renderable {
  const NullRenderbleObject();
  void render(CanvasScreen screen, Coordinate pos){}
}

/// 描画オブジェクトインターフェース
abstract class Renderable {
  void render(CanvasScreen screen, Coordinate pos);
}

/// メインシーン
class MainScene extends Scene {
  MainScene() : super() {
    addWindow(new StageWindow(new Grid(1, 1)));
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
    KeyCode.H: Direction.west,
    KeyCode.J: Direction.south,
    KeyCode.K: Direction.north,
    KeyCode.L: Direction.east,
    KeyCode.Y: Direction.northWest,
    KeyCode.U: Direction.northEast,
    KeyCode.B: Direction.southWest,
    KeyCode.N: Direction.southEast,
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
  /// 入力処理
  void keyDown(int key) {
    if (key == KeyCode.SPACE) {
      MessageWindow message_window = new MessageWindow(new Grid(5, 5));
      message_window.write("*** Test Message ***", 'Yellow');
      message_window.write("   multi line test  ");
      message_window.write("*                   ");
      Scene.activeScene.addWindow(message_window);
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
  /// 描画処理
  void render(CanvasScreen screen) {
    Stage.currentStage.render(screen, const Coordinate(2, 2));
  }
}


