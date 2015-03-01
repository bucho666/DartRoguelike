library stage;

import 'plane.dart';
import 'canvas_screen.dart';

/// 2次元配列
class Array2D<T> {
  List<T> _elements;
  final Size size;
  /// コンストラクタ
  Array2D(this.size, [T initial_value=null]) {
    _elements = new List<T>.filled(size.height * size.width, initial_value);
  }
  /// 座標リスト
  Iterable<Coordinate> get coordinates {
    int length = _elements.length;
    final List<Coordinate> coordinats = new List<Coordinate>(length);
    for (int index = 0; index < length; index++) {
      coordinats[index] = _coordinate(index);
    }
    return coordinats;
  }
  /// 値のイテレータ
  Iterator<T> get iterator => _elements.iterator;
  /// 指定座標の値を取得
  T operator [](Coordinate pos) => _elements[_index(pos)];
  /// 指定座標に値を設定
  void operator []=(Coordinate pos, T value) {
    _elements[_index(pos)] = value;
  }
  /// 指定値で埋める
  void fill(T value) => _elements.fillRange(0, _elements.length, value);
  /// indexから座標を返す
  Coordinate _coordinate(int index) => new Coordinate(index % size.width, index ~/ size.width);
  /// 座標から、実際のindexを返す
  int _index(Coordinate pos) => pos.y * size.width + pos.x;
}

/// 各種マップ(地形、キャラクター等)のファサードクラス
class Stage {
  static Stage _current_stage;
  static set current_stage(Stage new_stage) => _current_stage = new_stage;
  Array2D _terrain;
  Array2D _actor;

  Stage(Size size) {
    _terrain = new Array2D<String>(size, '.');
    _actor = new Array2D<String>(size);
  }

  void renderAt(CanvasScreen screen, Coordinate coordinate) {
    screen.write(_terrain[coordinate], 'silver', new Grid.asCoordinate(coordinate));
  }

  static void render(CanvasScreen screen) {
    for (Coordinate c in _current_stage._terrain.coordinates) {
      _current_stage.renderAt(screen, c);
    }
  }
}
