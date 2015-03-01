library stage;

import 'canvas_screen.dart';
import 'plane.dart';

class Actor extends Tile {
  Actor(String glyph, String color) : super(glyph, color);
}

/// 2次元配列
class Array2D<T> {
  List<T> _elements;
  final Size size;
  /// コンストラクタ
  Array2D(this.size, [T initial_value = null]) {
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
  static Stage get current_stage => _current_stage;
  static set current_stage(Stage new_stage) => _current_stage = new_stage;
  Array2D _terrain;
  Array2D _actor;

  Stage(Size size) {
    _terrain = new Array2D<Terrain>(size, const Terrain('.', 'silver'));
    _actor = new Array2D<Actor>(size);
  }

  Coordinate findActor(Actor actor) {
    for (Coordinate current in _actor.coordinates) {
      if (_actor[current] == actor) return current;
    }
    return null;
  }

  Actor pickupActor(Coordinate coordinate) {
    Actor actor = _actor[coordinate];
    _actor[coordinate] = null;
    return actor;
  }

  void putActor(Actor actor, Coordinate coordinate) {
    _actor[coordinate] = actor;
  }

  void render(CanvasScreen screen) {
    for (Coordinate coordinate in _current_stage._terrain.coordinates) {
      _current_stage.renderAt(screen, coordinate);
    }
  }

  void renderAt(CanvasScreen screen, Coordinate coordinate) {
    if (_actor[coordinate] != null) {
      _actor[coordinate].render(screen, new Grid.asCoordinate(coordinate));
    } else {
      _terrain[coordinate].render(screen, new Grid.asCoordinate(coordinate));
    }
  }
}

class Terrain extends Tile {
  const Terrain(String glyph, String color) : super(glyph, color);
}

class Tile {
  final String _glyph;
  final String _color;
  const Tile(this._glyph, this._color);
  void render(CanvasScreen screen, Coordinate coordinate) {
    screen.write(this._glyph, this._color, coordinate);
  }
}
