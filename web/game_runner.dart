library game_runner;

import 'dart:html';

class Game {
  void key_down(int key) {}
  void render() {}
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
