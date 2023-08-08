import 'package:tetris_game/values.dart';

class Piece {
  // type of tetris piece
  Tetromino type;

  Piece({required this.type});

  // The piece is just a list of integers
  List<int> position = [];
}
