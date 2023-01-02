import 'package:flutter/material.dart';

const BLOCKS_X = 10;
const BLOCKS_Y = 20;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: BLOCKS_X / BLOCKS_Y,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.indigo[800],
            border: Border.all(
              width: 2.0,
              color: Colors.indigoAccent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))
          ),
      ),
    );
  }
}
