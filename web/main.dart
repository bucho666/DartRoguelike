import 'dart:html';
import 'canvas_screen.dart';
import 'game_runner.dart';

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

  static CanvasScreen _build_screen() {
    Grid.size = new Size(10, 16);
    Size screen_size = new Size(80, 24);
    Font font = new Font("22px 'courier new'");
    String backgroundColor = "black";
    CanvasScreen screen = new CanvasScreen(_build_canvas(), screen_size, font, backgroundColor);
    screen.initialize();
    return screen;
  }

  static CanvasElement _build_canvas() {
    CanvasElement canvas = new CanvasElement();
    document.body.children.add(canvas);
    return canvas;
  }
}

/// 2次元配列
class Array2D<T> {
  List<T> _elements;
  final Size size;
  /// コンストラクタ
  Array2D(this.size) {
    _elements = new List<T>.filled(size.height*size.width, null);
  }
  /// 指定座標の値を取得
  T operator[](Coordinate pos) => _elements[_index(pos)];
  /// 指定座標に値を設定
  void operator[]=(Coordinate pos, T value) {
    _elements[_index(pos)] = value;
  }
  /// 指定値で埋める
  void fill(T value) => _elements.fillRange(0, _elements.length, value);
  /// 値のイテレータ
  Iterator<T> get iterator => _elements.iterator;
  /// 座標リスト
  Iterable<Coordinate> get coordinates {
    int length = _elements.length;
    final List<Coordinate> coordinats = new List<Coordinate>(length);
    for (int index = 0; index < length; index++) {
      coordinats[index] = _coordinate(index);
    }
    return coordinats;
  }
  /// 座標から、実際のindexを返す
  int _index(Coordinate pos) => pos.y * size.width + pos.x;
  /// indexから座標を返す
  Coordinate _coordinate(int index) => new Coordinate(index % size.width, index ~/ size.width);
}

/// 各種マップ(地形、キャラクター等)のファサードクラス
class Stage {
  static Stage _current_stage;
  static set current_stage(Stage new_stage) => _current_stage = new_stage;
  static void render(CanvasScreen screen) {
    for (Coordinate c in _current_stage._terrain.coordinates) {
      _current_stage.renderAt(screen, c);
    }
  }
  // TODO 地形タイル
  Array2D _terrain;

  Stage(Size size) {
    _terrain = new Array2D<String>(size);
    _terrain.fill('.');
  }

  void renderAt(CanvasScreen screen, Coordinate c) {
    screen.write(_terrain[c], 'silver', new Grid.asCoordinate(c));
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
  CanvasScreen _screen;
  WalkDemo(this._screen)
    : _pos = new Grid(3, 3) {
    Stage.current_stage = new Stage(new Size(80, 20));
  }


  void keyDown(int key) {
    if (_dirs.containsKey(key) == false) return;
    _pos += _dirs[key];
    render();
  }

  void render() {
    _screen.clear();
    Stage.render(_screen);
    _screen.write('@', 'olive', _pos);
  }
}
