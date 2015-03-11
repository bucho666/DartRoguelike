library canvas_screen;

import 'dart:html';
import 'plane.dart';

/// HTML5のキャンバスを操作するクラス
class CanvasScreen {
  final CanvasRenderingContext2D _context;
  final Font _font;
  final Size _size;
  final String _backgroundColor;

  CanvasScreen(CanvasElement canvas, Size size, this._font, this._backgroundColor)
      : _context = canvas.context2D
      , _size = new Size(Grid.width * size.width, Grid.height * size.height) {
    canvas
        ..width = _size.width
        ..height = _size.height;
    _context
      ..fillStyle = _backgroundColor
      ..textBaseline = 'top';
  }

  void clear() {
    _context
        ..clearRect(0, 0, _size.width, _size.height);
  }

  void initialize() {
    clear();
    _context.font = _font.family;
  }

  void write(String text, Coordinate pos, [String color]) {
    int width = _context.measureText(text).width.toInt();
    int height = _font.size;
    if (color != null) _context.fillStyle = color;
    _context
        ..clearRect(pos.x, pos.y, width, height)
        ..fillText(text, pos.x, pos.y);
  }
}

/// フォントクラス
class Font {
  final int size;
  final String family;
  Font(String name, int font_size)
      : family = "${font_size}px ${name}"
      , this.size = font_size;
}