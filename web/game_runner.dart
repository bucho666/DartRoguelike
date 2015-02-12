library game_runner;

import 'dart:html';

abstract class Game {
  void keyDown(int key);
  void render();
}

class GameRunner {
  final Game _game;
  GameRunner(this._game);

  void run() {
    _game.render();
    document.body.onKeyDown.listen(_key_down);
  }

  void _key_down(KeyboardEvent event) {
    _game.keyDown(event.keyCode);
    _game.render();
  }
}
