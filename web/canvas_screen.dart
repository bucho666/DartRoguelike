library canvas_screen;

import 'dart:html';

class Coordinate {
  int x;
  int y;
  Coordinate(this.x, this.y);
}

class Font {
  final String family;
  final Size _size;
  Font(this.family, this._size);
  int get height => _size.height;
  int get width => _size.width;
}

class CanvasScreen {
  CanvasRenderingContext2D _context;
  final Font _font;
  Size _size;
  String _background_color;
  CanvasScreen(CanvasElement canvas, Size size, this._font, this._background_color) {
    _context = canvas.context2D;
    _size = new Size(_font.width * size.width, _font.height * size.height);
    canvas
      ..width = _size.width
      ..height = _size.height;
  }

  void initialize() {
    clear();
    _context.font = _font.family;
  }

  void clear() {
    _context
      ..fillStyle = _background_color
      ..fillRect(0, 0, _size.width, _size.height);
  }

  void write(String text, String color, Coordinate pos) {
    _context
      ..fillStyle = color
      ..fillText(text, pos.x * _font.width, (pos.y  + 1) * _font.height);
  }
}

class Size {
  final int width;
  final int height;
  Size(this.width, this.height);
}