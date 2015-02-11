library canvas_screen;

import 'dart:html';

class CanvasScreen {
  CanvasRenderingContext2D _context;
  final Font _font;
  Size _size;
  String _background_color;
  CanvasScreen(CanvasElement canvas, Size size, this._font, this._background_color) {
    _context = canvas.context2D;
    _size = new Size(Grid.width * size.width, Grid.height * size.height);
    canvas
        ..width = _size.width
        ..height = _size.height;
  }

  void clear() {
    _context
        ..fillStyle = _background_color
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
  int _x;
  int _y;
  Coordinate(this._x, this._y);

  int get x => _x;
  int get y => _y;

  Coordinate operator +(Coordinate other) {
    return new Coordinate(_x + other._x, _y + other._y);
  }
}

class Direction {
  static final Coordinate N = new Coordinate(0, -1);
  static final Coordinate S = new Coordinate(0, 1);
  static final Coordinate E = new Coordinate(1, 0);
  static final Coordinate W = new Coordinate(-1, 0);
  static final Coordinate NE = new Coordinate(1, -1);
  static final Coordinate NW = new Coordinate(-1, -1);
  static final Coordinate SE = new Coordinate(1, 1);
  static final Coordinate SW = new Coordinate(-1, 1);
}

class Font {
  final String family;
  Font(this.family);
}

class Grid extends Coordinate {
  static Size _size;
  static get height => _size.height;
  static set size(Size size) => _size = size;
  static get width => _size.width;
  Grid(int x, int y) : super(x, y);
  int get x => _x * _size.width;
  int get y => _y * _size.height;
  Grid operator +(Coordinate other) {
    return new Grid(_x + other._x, _y + other._y);
  }
}

class Size {
  final int width;
  final int height;
  Size(this.width, this.height);
}
