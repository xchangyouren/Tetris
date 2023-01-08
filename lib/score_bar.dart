import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

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
            colors: [
              Color.fromARGB(255, 40, 53, 147),
              Color.fromARGB(255, 63, 81, 181)
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Score: ${Provider.of<Data>(context).score}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          ],
        ));
  }
}
