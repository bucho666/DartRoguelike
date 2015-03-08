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

/// フォントクラス
class Font {
  final String family;
  const Font(this.family);
}



