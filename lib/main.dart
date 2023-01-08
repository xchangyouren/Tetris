import 'package:flutter/material.dart';
import 'score_bar.dart';
import 'game.dart';
import 'next_block.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => Data(),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Tetris());
  }
}

class Tetris extends StatefulWidget {
  const Tetris({super.key});

  @override
  State<StatefulWidget> createState() => _TetrisState();
}

class _TetrisState extends State<Tetris> {
  final GlobalKey<GameState> _keyGame = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tetris'),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
      ),
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const ScoreBar(),
            Expanded(
                child: Center(
                    child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Flexible(
                    flex: 3,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        child: Game(
                          key: _keyGame,
                        ))),
                Flexible(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const NextBlock(),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    Provider.of<Data>(context, listen: false)
                                            .isPlaying
                                        ? _keyGame.currentState!.endGame()
                                        : _keyGame.currentState!.startGame();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo[700]),
                                child: Text(
                                  Provider.of<Data>(context, listen: false)
                                          .isPlaying
                                      ? 'End'
                                      : 'Start',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[200]),
                                )),
                          ],
                        ))),
              ],
            )))
          ],
        ),
      ),
    );
  }
}

class Data with ChangeNotifier {
  int score = 0;
  bool isPlaying = false;

  void setScore(int score) {
    this.score = score;
    notifyListeners();
  }

  void addScore(int score) {
    this.score += score;
    notifyListeners();
  }

  void setIsPlaying(bool isPlaying) {
    this.isPlaying = isPlaying;
    notifyListeners();
  }
}
