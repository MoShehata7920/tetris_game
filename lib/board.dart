import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  Piece currentPiece = Piece(type: Tetromino.L);

  int frameRateDuration = 650;

  int currentScore = 0;

  bool gameOver = false;

  Timer? gameTimer;

  @override
  void initState() {
    super.initState();

    // start the game when app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    // frame refresh rate
    Duration frameRate = Duration(milliseconds: frameRateDuration);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    // Store the Timer in the gameTimer variable
    gameTimer = Timer.periodic(frameRate, (timer) {
      setState(() {
        // clear lines
        clearLines();

        // check landing piece
        checkLanding();

        if (gameOver) {
          timer.cancel();
          showGameOverDialog();
        }

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

      // Check for collision with landed pieces when moving left or right
      if ((direction == Direction.left || direction == Direction.right) &&
          row >= 0 &&
          gameBoard[row][col] != null) {
        return true;
      }

      // Check for collision with landed pieces
      if (direction == Direction.down &&
          row >= 0 &&
          gameBoard[row][col] != null) {
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

    if (isGameOver()) {
      gameOver = true;
    }
  }

  // move  left
  void moveLeft() {
    // make sure the move is valid before moving
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // move  Down
  void moveDown() {
    // make sure the move is valid before moving
    if (!checkCollision(Direction.down)) {
      setState(() {
        currentPiece.movePiece(Direction.down);
      });
    }
  }

  // Rotate
  void rotate() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // move  Right
  void moveRight() {
    // make sure the move is valid before moving
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  // clear lines
  void clearLines() {
    // Loop through each row of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // Initialize a variable to track if the row is full
      bool rowIsFull = true;

      // check if the row if full
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // clear the row and shift row down if the row is full
      if (rowIsFull) {
        // move all above rows above the cleared row down by one position
        for (int i = row; i > 0; i--) {
          // copy the above row to the current new
          gameBoard[i] = List.from(
            gameBoard[i - 1],
          );
        }

        // set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);

        // Increase the score
        currentScore++;

        if (currentScore > 0 && frameRateDuration >= 100) {
          // Decrease frameRateDuration based on the number of lines cleared
          frameRateDuration -= currentScore * 10;
        }

        gameTimer?.cancel();

        // Create a new Timer with the updated frame rate
        Duration newFrameRate = Duration(milliseconds: frameRateDuration);
        gameLoop(newFrameRate);
      }
    }
  }

  // GameOve
  bool isGameOver() {
    // Check if all columns in the top row is fulled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    return false;
  }

  void showGameOverDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Row(
                children: [
                  SizedBox(
                      width: 30,
                      height: 30,
                      child: Lottie.asset("assets/json/game_over.json")),
                  const SizedBox(
                    width: 2,
                  ),
                  const Flexible(
                      child: Text(
                    "Game Over",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              content: Text("Your Score is $currentScore"),
              actions: [
                TextButton(
                    onPressed: () {
                      resetGame();

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Play Again",
                      style: TextStyle(color: Colors.cyan),
                    ))
              ],
            ));
  }

  void resetGame() {
    // clear the game board
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    gameOver = false;
    currentScore = 0;

    createNewPiece();

    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Game Board
          Expanded(
            child: GridView.builder(
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
                    return Pixel(color: currentPiece.color);
                  }

                  // landed piece
                  else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(color: tetrominoColors[tetrominoType]);
                  }

                  // blank pixels
                  else {
                    return Pixel(color: Colors.grey[900]);
                  }
                }),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: moveDown,
                  color: Colors.white,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 40,
                  )),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Score: $currentScore",
                style: const TextStyle(
                  color: Colors.cyan,
                ),
              ),
            ],
          ),

          // Game Controllers
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // left
                IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios_outlined)),

                // rotate
                IconButton(
                    onPressed: rotate,
                    color: Colors.white,
                    icon: const Icon(Icons.rotate_right)),

                // right
                IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_forward_ios_outlined)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
