// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'canvas_screen.dart';

class WalkDemo {
  Coordinate _pos;
  CanvasScreen _screen;
  WalkDemo(this._screen) {
    _pos = new Coordinate(3, 3);
  }

  void key_down(KeyboardEvent event) {
    switch (event.keyCode) {
      case 72: _pos.x -= 1; break;
      case 74: _pos.y += 1; break;
      case 75: _pos.y -= 1; break;
      case 76: _pos.x += 1; break;
    }
    render();

  }

  void render() {
    _screen.clear();
    _screen.write('@', 'olive', _pos);
  }
}

void main() {
  CanvasElement canvas = new CanvasElement();
  document.body.children.add(canvas);

  CanvasScreen screen = new CanvasScreen(canvas,
      new Size(80, 24),
      new Font("21px 'courier new'", new Size(10, 16)),
      "black");
  screen.initialize();
  WalkDemo demo = new WalkDemo(screen);
  demo.render();
  document.body.onKeyDown.listen(demo.key_down);
}