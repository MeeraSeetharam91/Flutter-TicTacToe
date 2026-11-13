import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../theme/wood_theme.dart';
import '../widgets/board_cell.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WoodTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Prominent title
            Text(
              'TIC TAC TOE',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: WoodTheme.textLight,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  Shadow(
                    color: WoodTheme.woodDark.withValues(alpha: 0.3),
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Scoreboard
            Consumer<GameProvider>(
              builder: (context, game, _) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      WoodTheme.woodDark,
                      WoodTheme.woodMedium,
                      WoodTheme.woodDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                  border: Border.all(
                    color: WoodTheme.frameBorder,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ScoreCard(
                      label: 'X',
                      score: game.xWins,
                      color: WoodTheme.xColor,
                    ),
                    _ScoreCard(
                      label: 'Draw',
                      score: game.draws,
                      color: WoodTheme.textOnWood,
                    ),
                    _ScoreCard(
                      label: 'O',
                      score: game.oWins,
                      color: WoodTheme.oColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Status message
            Consumer<GameProvider>(
              builder: (context, game, _) {
                String message;
                if (game.winner != null) {
                  message =
                      'Player ${game.playerSymbol(game.winner!)} wins!';
                } else if (game.isDraw) {
                  message = "It's a draw!";
                } else {
                  message =
                      'Player ${game.playerSymbol(game.currentPlayer)}\'s turn';
                }
                return Text(
                  message,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: WoodTheme.textLight,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // Board with wooden frame
            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxSize =
                        constraints.maxWidth < constraints.maxHeight
                            ? constraints.maxWidth
                            : constraints.maxHeight;
                    final boardSize = maxSize - 48; // padding for outer frame
                    return Container(
                      width: boardSize + 32,
                      height: boardSize + 32,
                      decoration: BoxDecoration(
                        // Wooden outer frame
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            WoodTheme.woodHighlight,
                            WoodTheme.frameColor,
                            WoodTheme.woodMedium,
                            WoodTheme.woodDark,
                          ],
                          stops: [0.0, 0.3, 0.7, 1.0],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            offset: const Offset(4, 6),
                            blurRadius: 12,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(2, 3),
                            blurRadius: 4,
                          ),
                        ],
                        border: Border.all(
                          color: WoodTheme.frameBorder,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        // Black recessed board surface
                        decoration: BoxDecoration(
                          color: WoodTheme.boardSurface,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.8),
                              offset: const Offset(0, 0),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) =>
                              BoardCell(index: index),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Consumer<GameProvider>(
                builder: (context, game, _) => Row(
                  children: [
                    Expanded(
                      child: _WoodButton(
                        label: 'New Game',
                        icon: Icons.replay,
                        onPressed:
                            game.isGameOver ? game.resetGame : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _WoodButton(
                      label: 'Reset',
                      icon: Icons.refresh,
                      onPressed: game.resetScores,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int score;
  final Color color;

  const _ScoreCard({
    required this.label,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$score',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: WoodTheme.textOnWood,
          ),
        ),
      ],
    );
  }
}

class _WoodButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const _WoodButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: enabled
                ? [WoodTheme.woodLight, WoodTheme.woodMedium]
                : [
                    WoodTheme.woodDark.withValues(alpha: 0.5),
                    WoodTheme.woodShadow.withValues(alpha: 0.5),
                  ],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    offset: const Offset(2, 3),
                    blurRadius: 4,
                  ),
                ]
              : [],
          border: Border.all(
            color: enabled ? WoodTheme.frameBorder : WoodTheme.woodShadow,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color:
                  enabled ? WoodTheme.textOnWood : WoodTheme.woodShadow,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: enabled
                    ? WoodTheme.textOnWood
                    : WoodTheme.woodShadow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
