import 'dart:math';

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

  String checkWinner() {
    String winner = '';

    //player X wins
    if (
    // Horizontal wins
    Player.playerX.containsAll(0, 1, 2) ||
        Player.playerX.containsAll(3, 4, 5) ||
        Player.playerX.containsAll(6, 7, 8) ||
        // Vertical wins
        Player.playerX.containsAll(0, 3, 6) ||
        Player.playerX.containsAll(1, 4, 7) ||
        Player.playerX.containsAll(2, 5, 8) ||
        // Diagonal wins
        Player.playerX.containsAll(0, 4, 8) ||
        Player.playerX.containsAll(2, 4, 6)) {
      winner = "X";
    }

    //player O wins
    if (
    // Horizontal wins
    Player.playerO.containsAll(0, 1, 2) ||
        Player.playerO.containsAll(3, 4, 5) ||
        Player.playerO.containsAll(6, 7, 8) ||
        // Vertical wins
        Player.playerO.containsAll(0, 3, 6) ||
        Player.playerO.containsAll(1, 4, 7) ||
        Player.playerO.containsAll(2, 5, 8) ||
        // Diagonal wins
        Player.playerO.containsAll(0, 4, 8) ||
        Player.playerO.containsAll(2, 4, 6)) {
      winner = "O";
    }

    return winner;
  }

  Future<void> autoPlay(activePlayer) async {
    int index = 0;
    List<int> emptyCells = [];
    for (var i = 0; i < 9; i++) {
      if (!(Player.playerO.contains(i) || Player.playerX.contains(i))) {
        emptyCells.add(i);
      }
    }

    // All possible win lines
    List<List<int>> winLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6], // diagonals
    ];

    List<int> myMoves = activePlayer == "X"
        ? List.from(Player.playerX)
        : List.from(Player.playerO);
    List<int> oppMoves = activePlayer == "X"
        ? List.from(Player.playerO)
        : List.from(Player.playerX);

    // 1. Try to win
    for (var line in winLines) {
      int countMine = 0;
      int empty = -1;
      for (var pos in line) {
        if (myMoves.contains(pos))
          countMine++;
        else if (emptyCells.contains(pos))
          empty = pos;
      }
      if (countMine == 2 && empty != -1) {
        index = empty;
        playGame(index, activePlayer);
        return;
      }
    }

    // 2. Block opponent
    for (var line in winLines) {
      int countOpp = 0;
      int empty = -1;
      for (var pos in line) {
        if (oppMoves.contains(pos))
          countOpp++;
        else if (emptyCells.contains(pos))
          empty = pos;
      }
      if (countOpp == 2 && empty != -1) {
        index = empty;
        playGame(index, activePlayer);
        return;
      }
    }

    // 3. Otherwise, pick randomly
    Random random = Random();
    int randomIndex = random.nextInt(emptyCells.length);
    index = emptyCells[randomIndex];
    playGame(index, activePlayer);
  }
}

//the extention function
extension ContainsAll on List {
  bool containsAll(int x, int y, [z]) {
    if (z == null) {
      return contains(x) && contains(y);
    } else {
      return contains(x) && contains(y) && contains(z);
    }
  }
}
