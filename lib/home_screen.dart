import 'package:flutter/material.dart';

import 'game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> with SingleTickerProviderStateMixin {
  //the animation effect
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isForbidden = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    // Shake animation: moves the widget left and right
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));

    // Color animation: transitions to red and back
    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Reset the animation after completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse().then((_) {
          setState(() {
            _isForbidden = false;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerForbiddenAction() {
    setState(() {
      _isForbidden = true;
    });
    _controller.forward();
  }

  //-------------------
  String activePlayer = 'X';
  bool gameOver = false;
  int turns = 0;
  String result = "";
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          children: [
            // the auto player switch
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 25, 43, 57),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SwitchListTile.adaptive(
                title: Text(!isSwitched ? 'Auto player' : "Two players"),
                value: isSwitched,
                onChanged: (newValue) {
                  setState(() {
                    isSwitched = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            //the turn ( X or O)
            Text.rich(
              style: TextStyle(fontSize: 40),
              TextSpan(
                style: TextStyle(fontSize: 40),
                children: [
                  TextSpan(text: "IT'S "),
                  TextSpan(
                    text: activePlayer == "X" ? "X" : "O",
                    style: TextStyle(
                      color: activePlayer == "X"
                          ? Colors.blueAccent
                          : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                  TextSpan(text: " TURN"),
                ],
              ),
            ),
            //the board grid
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: GridView.count(
                    padding: EdgeInsets.all(16),
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                    children: List.generate(
                      //generates 9 grids
                      9,
                      (index) => InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: gameOver
                            ? null
                            : () => _onTap(
                                index,
                              ), //if the game is over, the grid is not clickable
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isForbidden
                                ? _colorAnimation.value
                                : gameOver && activePlayer == "X"
                                ? Colors.redAccent.withOpacity(0.7)
                                : gameOver && activePlayer == "O" && turns != 9
                                ? Colors.blueAccent.withOpacity(0.7)
                                : const Color.fromARGB(255, 34, 40, 95),
                            borderRadius: BorderRadius.circular(16),
                          ),

                          child: Center(
                            child: Text(
                              Player.playerX.contains(index)
                                  ? "X"
                                  : Player.playerO.contains(index)
                                  ? "O"
                                  : "",
                              style: TextStyle(
                                fontSize: 50,
                                color: Player.playerX.contains(index)
                                    ? Colors.blueAccent
                                    : Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            //the result
            Text(result, style: TextStyle(fontSize: 28)),
            //repeat the game
            ElevatedButton.icon(
              icon: Icon(Icons.repeat),
              onPressed: () {
                setState(() {
                  Player.playerX = [];
                  Player.playerO = [];
                  activePlayer = 'X';
                  gameOver = false;
                  turns = 0;
                  result = "";
                });
              },
              label: Text("repeat the game"),
            ),
          ],
        ),
      ),
    );
  }

  //handles the grid tap
  void _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      _updateState();

      if (isSwitched && !gameOver) {
        await Future.delayed(Duration(milliseconds: 1200));
        game.autoPlay(activePlayer);
        _updateState();
      }
    } else {
      _triggerForbiddenAction();
    }
  }

  void _updateState() {
    setState(() {
      turns++;
      String winnerPlayer = game.checkWinner();
      activePlayer = (activePlayer == "X") ? "O" : "X";

      if (winnerPlayer != "") {
        result = "The winner player is $winnerPlayer";
        gameOver = true;
      } else if (!gameOver && turns == 9) {
        result = "It's a draw";
        gameOver = true;
      }
    });
  }
}
