# tic_tac_toe -  Flutter app
<img width="1170" height="2532" alt="Simulator Screenshot - iPhone 16e - 2026-11-13 at 20 27 30" src="https://github.com/user-attachments/assets/49cc75e0-5cb1-47f5-8971-d814d196984b" />


Here's the full flow of this **Tic Tac Toe** Flutter app:

---

## Project Structure

```
lib/
  main.dart                                  # App entry point
  presentation/
    providers/game_provider.dart              # State management (ChangeNotifier)
    screens/game_screen.dart                  # Main UI screen
    widgets/board_cell.dart                   # Individual board cell widget
```

## App Flow

### 1. Entry Point — <ref_file file="/Users/mseetharam/Documents/Project/Flutter-Apps/app-lite/lib/main.dart" />

- `main()` calls `runApp(TicTacToeApp())`.
- `TicTacToeApp` is a `StatelessWidget` that sets up:
  - **`MultiProvider`** at the app root (per AGENTS.md convention) with a single `ChangeNotifierProvider<GameProvider>`.
  - **`MaterialApp`** with Material 3, an indigo color scheme, light/dark themes (follows system mode), and `GameScreen` as the home route.

### 2. State Management — <ref_file file="/Users/mseetharam/Documents/Project/Flutter-Apps/app-lite/lib/presentation/providers/game_provider.dart" />

`GameProvider` extends `ChangeNotifier` and holds all game state:

- **Board state**: A flat `List<Player?>` of 9 cells (3x3 grid). `null` = empty, `Player.x` or `Player.o` = occupied.
- **Turn tracking**: `_currentPlayer` alternates between `Player.x` and `Player.o`.
- **Win detection**: `_checkWin()` checks 8 win patterns (3 rows, 3 columns, 2 diagonals). On a match, it sets `_winner` and records the `_winningLine` indices.
- **Draw detection**: `_checkDraw()` fires when no cells are `null` and there's no winner.
- **Score tracking**: Persistent counters for X wins, O wins, and draws across games.
- **Key methods**:
  - `makeMove(index)` — places current player's mark, checks win/draw, toggles turn, calls `notifyListeners()`.
  - `resetGame()` — clears the board for a new round (scores persist).
  - `resetScores()` — zeroes all scores and resets the board.

### 3. Main Screen — <ref_file file="/Users/mseetharam/Documents/Project/Flutter-Apps/app-lite/lib/presentation/screens/game_screen.dart" />

`GameScreen` is a `StatelessWidget` with a `Scaffold` containing:

| Section | Widget | What it does |
|---|---|---|
| **App Bar** | `AppBar` with refresh `IconButton` | Tapping the refresh icon calls `resetScores()` |
| **Scoreboard** | `Consumer<GameProvider>` wrapping a `Row` of 3 `_ScoreCard` widgets | Displays live X wins, draws, and O wins |
| **Status** | `Consumer<GameProvider>` with a `Text` | Shows "Player X's turn", "Player O wins!", or "It's a draw!" |
| **Board** | `LayoutBuilder` + `GridView.builder` (3x3) | Renders 9 `BoardCell` widgets, sized to fit the screen |
| **New Game** | `Consumer<GameProvider>` wrapping a `FilledButton` | Enabled only when the game is over; calls `resetGame()` |

The `_ScoreCard` is a private widget that renders a label and score in the player's color.

### 4. Board Cell — <ref_file file="/Users/mseetharam/Documents/Project/Flutter-Apps/app-lite/lib/presentation/widgets/board_cell.dart" />

Each `BoardCell` uses `Consumer<GameProvider>` to reactively rebuild when state changes:

- **Tap** calls `game.makeMove(index)`.
- **Visual state**: An `AnimatedContainer` highlights winning cells with `primaryContainer` color and a thicker border. An `AnimatedSwitcher` fades in the X/O text (X = primary color, O = error color).

## Data Flow Summary

```
User taps cell
    -> BoardCell.onTap
    -> GameProvider.makeMove(index)
        -> Updates board, checks win/draw, toggles player
        -> notifyListeners()
    -> All Consumer<GameProvider> widgets rebuild
        -> Scoreboard, status text, board cells, and button all update
```

This is a clean, single-screen app with no navigation/routing. All state lives in one `ChangeNotifier` provided at the root, and the UI reacts via `Consumer` widgets -- a straightforward provider pattern.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
