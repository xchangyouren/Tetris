import 'package:flutter/material.dart';
import 'score_bar.dart';
import 'game.dart';
import 'next_block.dart';

void main() => runApp(const MyApp());

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
                        child: Game())),
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
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo[700]),
                                child: Text(
                                  'Start',
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
