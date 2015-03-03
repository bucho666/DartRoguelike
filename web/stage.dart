library stage;

import 'canvas_screen.dart';
import 'plane.dart';

/// アクター(ゲームキャラクター)
class Actor extends Tile {
  Actor(String glyph, String color) : super(glyph, color);
}

/// 2次元配列
class Array2D<T> {
  final List<List<T>> _elements;
  final Size _size;
  /// コンストラクタ
  Array2D(Size size, [T initial_value = null])
      : _size = size
      , _elements = new List<List<T>>(size.height) {
      for (int y = 0; y < size.height; y++) {
        _elements[y] = new List<T>.filled(size.width, initial_value);
      }
  }

  /// 座標リスト
  Iterable<Coordinate> get coordinates {
    List<Coordinate> coordinates = new List<Coordinate>();
    for (int y = 0; y < _elements.length; y++) {
      for (int x = 0; x < _elements[y].length; x++)
        coordinates.add(new Coordinate(x, y));
    }
    return coordinates;
  }

  /// 指定座標の値を取得
  T operator [](Coordinate pos) => _elements[pos.y][pos.x];
  /// 指定座標に値を設定
  void operator []=(Coordinate pos, T value) {
    _elements[pos.y][pos.x] = value;
  }
}

/// 各種マップ(地形、キャラクター等)のファサードクラス
class Stage {
  static Stage _current_stage;
  static Stage get current_stage => _current_stage;
  static set current_stage(Stage new_stage) => _current_stage = new_stage;
  final Array2D<Terrain> _terrain;
  final Array2D<Actor> _actor;

  Stage(Size size)
      : _terrain = new Array2D<Terrain>(size, TerrainTable.get('.'))
      , _actor = new Array2D<Actor>(size);

  Coordinate findActor(Actor actor) {
    for (Coordinate current in _actor.coordinates) {
      if (_actor[current] == actor) return current;
    }
    return null;
  }

  bool movable(Coordinate coordinate) {
    return _terrain[coordinate].movable;
  }

  Actor pickupActor(Coordinate coordinate) {
    Actor actor = _actor[coordinate];
    _actor[coordinate] = null;
    return actor;
  }

  void putActor(Actor actor, Coordinate coordinate) {
    _actor[coordinate] = actor;
  }

  void render(CanvasScreen screen, Coordinate position) {
    for (Coordinate coordinate in _terrain.coordinates) {
      _current_stage.renderAt(screen, coordinate, position + coordinate);
    }
  }

  void renderAt(CanvasScreen screen, Coordinate coordinate, Coordinate position) {
    if (_actor[coordinate] != null) {
      _actor[coordinate].render(screen, new Grid.asCoordinate(position));
    } else {
      _terrain[coordinate].render(screen, new Grid.asCoordinate(position));
    }
  }

  void setTerrain(String symbol, Coordinate coordinate) {
    _terrain[coordinate] = TerrainTable.get(symbol);
  }

  List<Coordinate> get coordinates => _terrain.coordinates;
}

/// 地形タイル
class Terrain extends Tile {
  static const int MOVABLE = 1;
  final int _flags;

  const Terrain(String glyph, String color)
      : super(glyph, color),
        _flags = MOVABLE;

  const Terrain.Block(String glyph, String color)
      : super(glyph, color),
        _flags = 0;

  bool get movable => _flags & MOVABLE != 0;
}

/// 地形テーブル
class TerrainTable {
  static final Map<String, Terrain> _tabel = <String, Terrain> {
    '#': const Terrain.Block('#', 'Silver'),
    '.': const Terrain('.', 'Silver'),
  };

  static Terrain get(String symbol) {
    return _tabel[symbol];
  }
}

/// マップのタイル
class Tile {
  final String _glyph, _color;
  const Tile(this._glyph, this._color);
  void render(CanvasScreen screen, Coordinate coordinate) {
    screen.write(this._glyph, this._color, coordinate);
  }
}
