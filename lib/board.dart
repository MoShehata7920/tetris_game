import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tetris_game/piece.dart';
import 'package:tetris_game/pixel.dart';
import 'package:tetris_game/values.dart';

// create gameVBoard
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
    rowLength,
    (j) => null,
  ),
);

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
        // check landing piece
        checkLanding();

        // move current piece down
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  // check for collision in future position
  // return true -> there is a collision
  // return false -> there is no collision
  bool checkCollision(Direction direction) {
  for (int i = 0; i < currentPiece.position.length; i++) {
    int row = (currentPiece.position[i] / rowLength).floor();
    int col = (currentPiece.position[i] % rowLength);

    if (direction == Direction.left) {
      col -= 1;
    } else if (direction == Direction.right) {
      col += 1;
    } else if (direction == Direction.down) {
      row += 1;
    }

    if (row >= colLength || col < 0 || col >= rowLength) {
      return true;
    }

    // Check for collision with landed pieces
    if (direction == Direction.down && row >= 0 && gameBoard[row][col] != null) {
      return true;
    }
  }
  return false;
}

  void checkLanding() {
    // if going down to occupied
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gameBoard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = (currentPiece.position[i] % rowLength);

        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      // once landed create the next piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a random object to generate random tetromino type
    Random random = Random();

    // create a new piece with random type
    Tetromino randomType =
        Tetromino.values[random.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
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
            // get row  and col of each index
            int row = (index / rowLength).floor();
            int col = (index % rowLength);

            // current piece
            if (currentPiece.position.contains(index)) {
              return Pixel(color: Colors.red, child: index);
            }

            // landed piece
            else if (gameBoard[row][col] != null) {
              return Pixel(color: Colors.amber, child: '');
            }

            // blank pixels
            else {
              return Pixel(color: Colors.grey[900], child: index);
            }
          }),
    );
  }
}
