import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../theme/wood_theme.dart';

class BoardCell extends StatelessWidget {
  final int index;

  const BoardCell({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final cell = game.board[index];
        final isWinning = game.winningLine.contains(index);

        return GestureDetector(
          onTap: () => game.makeMove(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              // Wood grain gradient for the block face
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isWinning
                    ? [
                        WoodTheme.woodHighlight,
                        WoodTheme.woodLight.withValues(alpha: 0.9),
                      ]
                    : [
                        WoodTheme.woodHighlight,
                        WoodTheme.woodLight,
                        WoodTheme.woodMedium,
                      ],
                stops: isWinning ? null : const [0.0, 0.4, 1.0],
              ),
              borderRadius: BorderRadius.circular(6),
              // 3D raised block effect using box shadows
              boxShadow: [
                // Bottom-right shadow (depth illusion)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(3, 4),
                  blurRadius: 1,
                ),
                // Subtle secondary shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  offset: const Offset(2, 3),
                  blurRadius: 0,
                ),
                // Top-left highlight glow (bevel illusion)
                BoxShadow(
                  color: WoodTheme.woodHighlight.withValues(alpha: 0.6),
                  offset: const Offset(-1, -1),
                  blurRadius: 1,
                ),
              ],
              border: Border.all(
                color: WoodTheme.woodShadow.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: cell == null
                    ? const SizedBox.shrink()
                    : Text(
                        game.playerSymbol(cell),
                        key: ValueKey('$index-$cell'),
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: cell == Player.x
                              ? WoodTheme.xColor
                              : WoodTheme.oColor,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              offset: const Offset(1, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
