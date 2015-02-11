// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'canvas_screen.dart';

class Game {
  void render() {}
  void key_down(int key) {}
}

class GameRunner {
  Game _game;
  GameRunner(this._game);
  void run() {
    _game.render();
    document.body.onKeyDown.listen(_key_down);
  }

  void _key_down(KeyboardEvent event) {
    _game.key_down(event.keyCode);
    _game.render();
  }
}

class WalkDemo implements Game {
  Coordinate _pos;
  CanvasScreen _screen;
  WalkDemo(this._screen) {
    _pos = new Coordinate(3, 3);
  }

  void key_down(int key) {
    switch (key) {
      case 72:
        _pos.x -= 1;
        break;
      case 74:
        _pos.y += 1;
        break;
      case 75:
        _pos.y -= 1;
        break;
      case 76:
        _pos.x += 1;
        break;
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
  Size screen_size = new Size(80, 24);
  Font font = new Font("21px 'courier new'", new Size(10, 16));
  String background_color = "black";
  CanvasScreen screen = new CanvasScreen(canvas, screen_size, font, background_color);
  screen.initialize();
  GameRunner runner = new GameRunner(new WalkDemo(screen));
  runner.run();
}
