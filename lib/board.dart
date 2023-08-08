import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tetris_game/piece.dart';
import 'package:tetris_game/pixel.dart';
import 'package:tetris_game/values.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // current tetris piece
  Piece currentPiece = Piece(type: Tetromino.S);

  @override
  void initState() {
    super.initState();

    // start the game when app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    // frame refresh rate
    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        // move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rowLength * colLength,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowLength),
          itemBuilder: (context, index) {
            if (currentPiece.position.contains(index)) {
              return Pixel(color: Colors.red, child: index);
            } else {
              return Pixel(color: Colors.grey[900], child: index);
            }
          }),
    );
  }
}
