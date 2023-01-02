import 'package:flutter/material.dart';

class ScoreBar extends StatefulWidget {
  const ScoreBar({super.key});

  @override
  State<StatefulWidget> createState() => _ScoreBarState();
}

class _ScoreBarState extends State {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 40, 53, 147), Color.fromARGB(255, 63, 81, 181)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Score: 0',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          )
        ],
      )
    );
  }
}
