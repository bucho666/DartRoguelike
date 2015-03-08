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

/// シーンクラス
abstract class Scene {
  static Scene active_scene;
  /// 入力処理
  void keyDown(int key);
  /// 描画処理
  void render(CanvasScreen screen);
}

/// タイトルシーン
class TitleScene implements Scene {
  void keyDown(int key) {
    if (KeyCode.SPACE != key) return;
    Scene.active_scene = new MainScene();
  }

  void render(CanvasScreen screen) {
    screen.clear();
    int x = 28, y = 8;
    String titleColor = 'Yellow';
    screen.write("  ********************", titleColor, new Grid(x, y));
    screen.write(" *                    *", titleColor, new Grid(x, y + 1));
    screen.write("*  The RogueLike Game  *", titleColor, new Grid(x, y + 2));
    screen.write(" *                    *", titleColor, new Grid(x, y + 3));
    screen.write("  ********************", titleColor, new Grid(x, y + 4));
    screen.write("   (Press Space Key)", 'Silver', new Grid(x, y + 6));
  }
}

/// メインシーン
class MainScene implements Scene {
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
  final Actor _hero;

  MainScene()
      : _hero = new Actor('@', 'olive') {
    final List<String> terrainLines = [
        '##############################',
        '#..................##.....####',
        '#.######..########.##........#',
        '#.#...###.###....#.##.....#..#',
        '#.....#.....#....#.#########.#',
        '#.#...#.....#....#...........#',
        '##############################',
        ];
    Stage.currentStage = buildMap(terrainLines);
    Stage.currentStage.putActor(_hero, const Coordinate(3, 3));
  }
  // TODO 名前をリファクタリング(変数はlowerCamelCase)
  // TODO TileにonStandEventプロパティを追加
  // TODO タイルにキャラクターが載った時に実行する。
  // TODO イベントはまずは引数なしで。
  // TODO デフォルトは何もしない。
  // TODO とりあえずprintするイベントを作成
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
    if (_dirs.containsKey(key) == false) return;
    Coordinate current = Stage.currentStage.findActor(_hero);
    Coordinate to = current + _dirs[key];
    if (Stage.currentStage.movable(to) == false) return;
    Stage.currentStage
        ..pickupActor(current)
        ..putActor(_hero, to);
  }

  void render(CanvasScreen screen) {
    screen.clear();
    Stage.currentStage.render(screen, const Coordinate(2, 2));
  }
}

/// WalkDemo
class WalkDemo implements Game {
  final CanvasScreen _screen;

  WalkDemo(this._screen) {
    Scene.active_scene = new TitleScene();
  }

  void keyDown(int key) {
    Scene.active_scene.keyDown(key);
  }

  void render() {
    Scene.active_scene.render(_screen);
  }
}
