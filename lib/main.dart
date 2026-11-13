import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'presentation/providers/game_provider.dart';
import 'presentation/screens/game_screen.dart';
import 'presentation/theme/wood_theme.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'Tic Tac Toe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: WoodTheme.background,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.brown,
            surface: WoodTheme.background,
          ),
          useMaterial3: true,
        ),
        home: const GameScreen(),
      ),
    );
  }
}
