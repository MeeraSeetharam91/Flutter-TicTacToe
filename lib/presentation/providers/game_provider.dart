import 'package:flutter/foundation.dart';

enum Player { x, o }

class GameProvider extends ChangeNotifier {
  static const int boardSize = 3;

  List<Player?> _board = List.filled(boardSize * boardSize, null);
  Player _currentPlayer = Player.x;
  Player? _winner;
  bool _isDraw = false;
  List<int> _winningLine = [];

  // Score tracking
  int _xWins = 0;
  int _oWins = 0;
  int _draws = 0;

  List<Player?> get board => List.unmodifiable(_board);
  Player get currentPlayer => _currentPlayer;
  Player? get winner => _winner;
  bool get isDraw => _isDraw;
  bool get isGameOver => _winner != null || _isDraw;
  List<int> get winningLine => List.unmodifiable(_winningLine);
  int get xWins => _xWins;
  int get oWins => _oWins;
  int get draws => _draws;

  static const List<List<int>> _winPatterns = [
    [0, 1, 2], // rows
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6], // columns
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8], // diagonals
    [2, 4, 6],
  ];

  void makeMove(int index) {
    if (isGameOver || index < 0 || index >= 9 || _board[index] != null) return;

    _board[index] = _currentPlayer;
    _checkWin();
    if (_winner == null) {
      _checkDraw();
    }
    if (!isGameOver) {
      _currentPlayer = _currentPlayer == Player.x ? Player.o : Player.x;
    }
    notifyListeners();
  }

  void _checkWin() {
    for (final pattern in _winPatterns) {
      final a = _board[pattern[0]];
      final b = _board[pattern[1]];
      final c = _board[pattern[2]];
      if (a != null && a == b && b == c) {
        _winner = a;
        _winningLine = pattern;
        if (a == Player.x) {
          _xWins++;
        } else {
          _oWins++;
        }
        return;
      }
    }
  }

  void _checkDraw() {
    if (!_board.contains(null)) {
      _isDraw = true;
      _draws++;
    }
  }

  void resetGame() {
    _board = List.filled(boardSize * boardSize, null);
    _currentPlayer = Player.x;
    _winner = null;
    _isDraw = false;
    _winningLine = [];
    notifyListeners();
  }

  void resetScores() {
    _xWins = 0;
    _oWins = 0;
    _draws = 0;
    resetGame();
  }

  String playerSymbol(Player player) => player == Player.x ? 'X' : 'O';
}
