// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

void main() {
  CanvasElement canvas = new CanvasElement();
  document.body.children.add(canvas);
  Screen screen = new Screen(canvas,
      new Size(80, 24),
      new Font("16px 'courier new'", new Size(10, 16)),
      "black");
  screen
    ..initialize()
    ..write('start', 'red', new Coordinate(0, 0))
    ..clear()
    ..write('end', 'red', new Coordinate(0, 0));
}

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

class Screen {
  CanvasRenderingContext2D _context;
  final Font _font;
  Size _size;
  String _background_color;
  Screen(CanvasElement canvas, Size size, this._font, this._background_color) {
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
