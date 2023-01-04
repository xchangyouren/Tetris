import 'package:flutter/material.dart';
import 'package:my_tetris/blcok.dart';
import 'dart:math';
import 'dart:async';

const BLOCKS_X = 10;
const BLOCKS_Y = 20;
const REFRESH_GAME = 1;
const GAME_AREA_BORDER_WIDTH = 2.0;
const SUB_BLOCK_EDGE_WIDTH = 2.0;

class Game extends StatefulWidget {
  // const Game({super.key});
  const Game({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GameState();
}

class GameState extends State<Game> {
  late double subBlockWidth;
  Duration duration = const Duration(seconds: REFRESH_GAME);

  final GlobalKey _keyGameArea = GlobalKey();

  Block? block;
  late Timer timer;
  bool isPlaying = false;

  Block getNewBlock() {
    int blockType = Random().nextInt(7);
    int orientationIndex = Random().nextInt(4);
    switch (blockType) {
      case 0:
        return IBlock(orientationIndex);
      case 1:
        return JBlock(orientationIndex);
      case 2:
        return SBlock(orientationIndex);
      case 3:
        return LBlock(orientationIndex);
      case 4:
        return TBlock(orientationIndex);
      case 5:
        return ZBlock(orientationIndex);
      case 6:
        return OBlock(orientationIndex);
      default:
        return OBlock(orientationIndex);
    }
  }

  void onPlay(Timer timer) {
    // debugPrint('onPlay called ${timer.tick}');
    setState(() {
      block?.move(BlockMovement.DOWN);
    });
  }

  void startGame() {
    isPlaying = true;
    RenderBox renderBoxGame =
        _keyGameArea.currentContext?.findRenderObject() as RenderBox;
    Offset position = renderBoxGame.localToGlobal(Offset.zero);
    debugPrint(
        'renderBoxGame position and size: ${position.dx} - ${position.dy} : ${renderBoxGame.size.width} ${renderBoxGame.size.height}');
    subBlockWidth =
        (renderBoxGame.size.width - GAME_AREA_BORDER_WIDTH * 2) / BLOCKS_X;
    block = getNewBlock();
    // debugPrint('subBlockWidth: $subBlockWidth, ${block?.x}-${block?.y}');
    timer = Timer.periodic(duration, onPlay);
  }

  void endGame() {
    isPlaying = false;
    timer.cancel();
    debugPrint('timer cancel');
  }

  Positioned getPositionedSquareContainer(Color color, int x, int y) {
    // debugPrint('getPositionedSquareContainer: $x - $y');
    return Positioned(
      left: x * subBlockWidth,
      top: y * subBlockWidth,
      child: Container(
        width: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
        height: subBlockWidth - SUB_BLOCK_EDGE_WIDTH,
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(3.0))),
      ),
    );
  }

  Widget? drawBlocks() {
    if (block == null) {
      return null;
    }
    List<Positioned> subBlocks = [];
    // current block
    block!.subBlocks.forEach((subBlock) {
      subBlocks.add(getPositionedSquareContainer(
          subBlock.color, subBlock.x + block!.x, subBlock.y + block!.y));
    });
    // debugPrint('drawBlocks: ${subBlocks[0].left}-${subBlocks[0].top}');
    return Stack(
      children: subBlocks,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: BLOCKS_X / BLOCKS_Y,
      child: Container(
        key: _keyGameArea,
        decoration: BoxDecoration(
            color: Colors.indigo[800],
            border: Border.all(
              width: 2.0,
              color: Colors.indigoAccent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: drawBlocks(),
      ),
    );
  }
}
