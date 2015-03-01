library game_runner;

import 'dart:html';

/// ゲームの抽象クラス
/// キー入力、描画処理を実装する。
abstract class Game {
  void keyDown(int key);
  void render();
}

/// ゲームの実行クラス
/// ゲームに対して入力や描画を命令する。
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
