import 'package:flutter/material.dart';

import 'game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _State();
}

class _State extends State<HomeScreen> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = "xxxxxxxxxxxx";
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
                title: const Text('Auto player'),
                value: isSwitched,
                onChanged: (newValue) {
                  setState(() {
                    isSwitched = newValue;
                  });
                },
              ),
            ),
            //the turn
            Text(
              "It's $activePlayer turn".toUpperCase(),
              style: TextStyle(fontSize: 40),
            ),
            //the result
            Text(result, style: TextStyle(fontSize: 28)),
            //repeat the game
            ElevatedButton.icon(
              icon: Icon(Icons.repeat),
              onPressed: () {
                setState(() {
                  activePlayer = 'X';
                  gameOver = false;
                  turn = 0;
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
}
