library plane;

/// 座標クラス
class Coordinate {
  final int _x;
  final int _y;
  const Coordinate(this._x, this._y);
  int get x => _x;
  int get y => _y;

  Coordinate operator +(Coordinate other) {
    return new Coordinate(_x + other._x, _y + other._y);
  }

  String toString() => "${_x}, ${_y}";
}

/// 方向の定数クラス
class Direction {
  static const Coordinate N = const Coordinate(0, -1);
  static const Coordinate S = const Coordinate(0, 1);
  static const Coordinate E = const Coordinate(1, 0);
  static const Coordinate W = const Coordinate(-1, 0);
  static const Coordinate NE = const Coordinate(1, -1);
  static const Coordinate NW = const Coordinate(-1, -1);
  static const Coordinate SE = const Coordinate(1, 1);
  static const Coordinate SW = const Coordinate(-1, 1);
}

class Grid extends Coordinate {
  static Size _size;
  static get height => _size.height;
  static set size(Size size) => _size = size;
  static get width => _size.width;
  const Grid(int x, int y) : super(x, y);
  Grid.asCoordinate(Coordinate c) : super(c.x, c.y);
  int get x => _x * _size.width;
  int get y => _y * _size.height;

  Grid operator +(Coordinate other) {
    return new Grid(_x + other._x, _y + other._y);
  }
}

class Size {
  final int width, height;
  const Size(this.width, this.height);
}
