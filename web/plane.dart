library plane;

/// 座標クラス
class Coordinate {
  final int _x, _y;
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
  static const Coordinate north = const Coordinate(0, -1);
  static const Coordinate south = const Coordinate(0, 1);
  static const Coordinate east = const Coordinate(1, 0);
  static const Coordinate west = const Coordinate(-1, 0);
  static const Coordinate northEast = const Coordinate(1, -1);
  static const Coordinate northWest = const Coordinate(-1, -1);
  static const Coordinate southEast = const Coordinate(1, 1);
  static const Coordinate southWest = const Coordinate(-1, 1);
  static const Coordinate upper = const Coordinate(0, -1);
  static const Coordinate lower = const Coordinate(0, 1);
  static const Coordinate right = const Coordinate(1, 0);
  static const Coordinate left = const Coordinate(-1, 0);
  static const Coordinate upperRight = const Coordinate(1, -1);
  static const Coordinate upperLeft = const Coordinate(-1, -1);
  static const Coordinate lowerRight = const Coordinate(1, 1);
  static const Coordinate lowerLeft = const Coordinate(-1, 1);

}

class Grid extends Coordinate {
  static Size _size;
  static set size(Size size) => _size = size;
  static get height => _size.height;
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
  Size expand(int size) => new Size(width + size * 2, height + size * 2);
}
