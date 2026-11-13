import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:tic_tac_toe/presentation/providers/game_provider.dart';
import 'package:tic_tac_toe/presentation/screens/game_screen.dart';
import 'package:tic_tac_toe/presentation/widgets/board_cell.dart';

Widget _buildTestApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GameProvider()),
    ],
    child: const MaterialApp(home: GameScreen()),
  );
}

void main() {
  testWidgets('Game screen renders board with 9 cells',
      (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp());
    expect(find.byType(BoardCell), findsNWidgets(9));
    expect(find.text("Player X's turn"), findsOneWidget);
  });

  testWidgets('Tapping a cell places X then O', (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp());

    final cells = find.byType(BoardCell);

    // Tap first cell - X
    await tester.tap(cells.at(0));
    await tester.pumpAndSettle();
    expect(find.text("Player O's turn"), findsOneWidget);

    // Tap second cell - O
    await tester.tap(cells.at(1));
    await tester.pumpAndSettle();
    expect(find.text("Player X's turn"), findsOneWidget);
  });

  testWidgets('X wins with top row', (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp());
    final cells = find.byType(BoardCell);

    // X: 0, O: 3, X: 1, O: 4, X: 2  => X wins top row
    await tester.tap(cells.at(0));
    await tester.pumpAndSettle();
    await tester.tap(cells.at(3));
    await tester.pumpAndSettle();
    await tester.tap(cells.at(1));
    await tester.pumpAndSettle();
    await tester.tap(cells.at(4));
    await tester.pumpAndSettle();
    await tester.tap(cells.at(2));
    await tester.pumpAndSettle();

    expect(find.text('Player X wins!'), findsOneWidget);
  });

  testWidgets('Draw scenario', (WidgetTester tester) async {
    await tester.pumpWidget(_buildTestApp());
    final cells = find.byType(BoardCell);

    // X O X
    // X X O
    // O X O
    final moves = [0, 1, 2, 4, 3, 5, 7, 6, 8];
    for (final move in moves) {
      await tester.tap(cells.at(move));
      await tester.pumpAndSettle();
    }

    expect(find.text("It's a draw!"), findsOneWidget);
  });

  test('GameProvider reset clears board', () {
    final game = GameProvider();
    game.makeMove(0);
    game.makeMove(1);
    game.resetGame();

    expect(game.board.every((cell) => cell == null), isTrue);
    expect(game.currentPlayer, Player.x);
    expect(game.winner, isNull);
    expect(game.isDraw, isFalse);
  });
}
