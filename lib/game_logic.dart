class Player {
  static const x = 'X';
  static const o = 'O';
  static const empty = '';
  static List<int> playerX = []; //index of the player X
  static List<int> playerO = []; //index of the player O
}

class Game {
  void playGame(int index, String activePlayer) {
    if (activePlayer == "X") {
      Player.playerX.add(index);
    } else {
      Player.playerO.add(index);
    }
  }

  checkWinner() {}
  autoPlay() {}
}
