import 'package:flutter/material.dart';
import 'score_bar.dart';
import 'game.dart';
import 'next_block.dart';
import 'package:provider/provider.dart';
import 'blcok.dart';
import 'package:flutter/services.dart';
import 'control_panel.dart';

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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
                                      ? 'Pause'
                                      : 'Start',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[200]),
                                )),
                          ],
                        ))),
              ],
            ))),
            const ControlPanel(),
          ],
        ),
      ),
    );
  }
}

class Data with ChangeNotifier {
  int score = 0;
  bool isPlaying = false;
  late Block nextBlock;
  BlockMovement? _nextAction;

  BlockMovement? get nextAction => _nextAction;

  set nextAction(BlockMovement? value) {
    _nextAction = value;
    notifyListeners();
  }

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

  void setNextBlock(nextBlock) {
    this.nextBlock = nextBlock;
    notifyListeners();
  }

  Widget getNextBlockWidget() {
    if (!isPlaying) {
      return Container();
    }
    var width = nextBlock.width;
    var height = nextBlock.height;
    Color color;

    List<Widget> columns = [];
    for (var y = 0; y < height; y++) {
      List<Widget> rows = [];
      for (var x = 0; x < width; x++) {
        if (nextBlock.subBlocks
                .where((subBlock) => subBlock.x == x && subBlock.y == y)
                .length >
            0) {
          color = nextBlock.color;
        } else {
          color = Colors.transparent;
        }
        rows.add(Container(
          width: 12,
          height: 12,
          color: color,
        ));
      }
      columns.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: columns,
    );
  }
}
