import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'blcok.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({super.key});

  @override
  State<StatefulWidget> createState() => _ControlPanelState();
}

class _ControlPanelState extends State {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<Data>(context, listen: false).nextAction =
                        BlockMovement.UP;
                  },
                  child: const Text("Up",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<Data>(context, listen: false).nextAction =
                            BlockMovement.LEFT;
                      },
                      child: const Text(
                        "Left",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<Data>(context, listen: false).nextAction =
                            BlockMovement.RIGHT;
                      },
                      child: const Text("Right"),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<Data>(context, listen: false).nextAction =
                        BlockMovement.DOWN;
                  },
                  child: const Text("Down"),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<Data>(context, listen: false)
                    .nextAction = (BlockMovement.ROTATE_CLOCKWISE);
              },
              child: const Text("Rotate"),
            ),
          ],
        ),
      ],
    );
  }
}
