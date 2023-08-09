// Grid dimensions
import 'package:flutter/material.dart';

int rowLength = 10;
int colLength = 15;

enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}

enum Direction {
  left,
  right,
  down,
}

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color(0xFFFF6347),
  Tetromino.J: Color(0xFFCC5500),
  Tetromino.I: Color(0xFFFFdf00),
  Tetromino.O: Color(0xFF00ff00),
  Tetromino.S: Color(0xFF48d1cc),
  Tetromino.Z: Color(0xFFee82ee),
  Tetromino.T: Color(0xFF918151),
};
