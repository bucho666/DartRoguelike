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
      : _size = size,
        _elements = new List<List<T>>(size.height) {
    for (int y = 0; y < size.height; y++) {
      _elements[y] = new List<T>.filled(size.width, initial_value);
    }
  }

  /// 座標リスト
  Iterable<Coordinate> get coordinates {
    List<Coordinate> coordinates = new List<Coordinate>();
    for (int y = 0; y < _elements.length; y++) {
      for (int x = 0; x < _elements[y].length; x++) coordinates.add(new Coordinate(x, y));
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

/// ステージの升目
class Cell {
  Terrain _terrain;
  Actor _actor;
  Event _onRiding;

  Cell(Terrain tile)
      : _terrain = tile,
        _actor = null,
        _onRiding = const NullEvent();

  Actor get actor => _actor;
  set actor(Actor actor) => _actor = actor;
  bool get movable => _terrain.movable;
  set onRiding(Event event) => _onRiding = event;
  set terrain(Terrain terrain) => _terrain = terrain;

  Actor pickupActor() {
    Actor actor = _actor;
    _actor = null;
    return actor;
  }

  void render(CanvasScreen screen, Coordinate renderTo) {
    if (_actor != null) {
      _actor.render(screen, new Grid.asCoordinate(renderTo));
    } else {
      _terrain.render(screen, new Grid.asCoordinate(renderTo));
    }
  }
}

/// イベントインターフェース
abstract class Event {
  void call(Actor actor);
}

/// Nullイベント
class NullEvent implements Event {
  const NullEvent();
  void call(Actor actor) { /* 何もしない */ }
}

/// 各種マップ(地形、キャラクター等)のファサードクラス
class Stage {
  static Stage _current_stage;
  static Stage get currentStage => _current_stage;
  static set currentStage(Stage newStage) => _current_stage = newStage;
  final Array2D<Cell> _cells;

  Stage(Size size)
      : _cells = new Array2D<Cell>(size) {
    for (Coordinate current in _cells.coordinates) {
      _cells[current] = new Cell(TerrainTable.get('.'));
    }
  }

  List<Coordinate> get coordinates => _cells.coordinates;

  Coordinate findActor(Actor actor) {
    for (Coordinate current in _cells.coordinates) {
      if (_cells[current].actor == actor) return current;
    }
    return null;
  }

  bool movable(Coordinate coordinate) {
    return _cells[coordinate].movable;
  }

  Actor pickupActor(Coordinate coordinate) {
    return _cells[coordinate].pickupActor();
  }

  void putActor(Actor actor, Coordinate coordinate) {
    _cells[coordinate].actor = actor;
  }

  void render(CanvasScreen screen, Coordinate position) {
    for (Coordinate coordinate in _cells.coordinates) {
      renderAt(screen, coordinate, position + coordinate);
    }
  }

  void renderAt(CanvasScreen screen, Coordinate coordinate, Coordinate renderTo) {
    _cells[coordinate].render(screen, renderTo);
  }

  void setTerrain(String symbol, Coordinate coordinate) {
    _cells[coordinate].terrain = TerrainTable.get(symbol);
  }
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
  static final Map<String, Terrain> _tabel = <String, Terrain>{
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
    screen.write(this._glyph, coordinate, this._color);
  }
}
