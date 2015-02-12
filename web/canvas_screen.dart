library canvas_screen;

import 'dart:html';

class CanvasScreen {
  final CanvasRenderingContext2D _context;
  final Font _font;
  final Size _size;
  final String _backgroundColor;

  CanvasScreen(CanvasElement canvas, Size size, this._font, this._backgroundColor)
      : _context = canvas.context2D,
        _size = new Size(Grid.width * size.width, Grid.height * size.height) {
    canvas
        ..width = _size.width
        ..height = _size.height;
  }

  void clear() {
    _context
        ..fillStyle = _backgroundColor
        ..fillRect(0, 0, _size.width, _size.height);
  }

  void initialize() {
    clear();
    _context.font = _font.family;
  }

  void write(String text, String color, Coordinate pos) {
    _context
        ..fillStyle = color
        ..fillText(text, pos.x, pos.y + 1);
  }
}

class Coordinate {
  final int _x;
  final int _y;
  const Coordinate(this._x, this._y);
  int get x => _x;
  int get y => _y;

  Coordinate operator +(Coordinate other) {
    return new Coordinate(_x + other._x, _y + other._y);
  }
}

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

class Font {
  final String family;
  const Font(this.family);
}

class Grid extends Coordinate {
  static Size _size;
  static get height => _size.height;
  static get width => _size.width;
  static set size(Size size) => _size = size;
  const Grid(int x, int y) : super(x, y);
  int get x => _x * _size.width;
  int get y => _y * _size.height;

  Grid operator +(Coordinate other) {
    return new Grid(_x + other._x, _y + other._y);
  }
}

class Size {
  final int width;
  final int height;
  const Size(this.width, this.height);
}
