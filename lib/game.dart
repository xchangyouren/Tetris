import 'package:flutter/material.dart';
import 'package:my_tetris/blcok.dart';
import 'dart:math';
import 'dart:async';
import 'main.dart';
import 'package:provider/provider.dart';

import 'package:my_tetris/sub_block.dart';

enum Collision { LANDED, LANDED_BLOCK, HIT_WALL, HIT_BLOCK, NONE }

const BLOCKS_X = 10;
const BLOCKS_Y = 20;
const REFRESH_GAME = 300;
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
  Duration duration = const Duration(milliseconds: REFRESH_GAME);

  final GlobalKey _keyGameArea = GlobalKey();

  BlockMovement? action;
  Block? block;
  late Timer timer;
  List<SubBlock> oldSubBlocks = <SubBlock>[];
  bool isGameOver = false;

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

  bool checkAtBottom() {
    return (block?.y)! + block?.height >= BLOCKS_Y;
  }

  bool checkAboveBlock() {
    for (var oldSubBlock in oldSubBlocks) {
      for (var subBlock in block?.subBlocks) {
        var x = subBlock.x + block?.x;
        var y = subBlock.y + block?.y;
        if (x == oldSubBlock.x && y + 1 == oldSubBlock.y) {
          return true;
        }
      }
    }
    return false;
  }

  bool checkOnEdge(BlockMovement action) {
    return action == BlockMovement.LEFT && (block?.x)! <= 0 ||
        action == BlockMovement.RIGHT && (block?.x)! + block?.width >= BLOCKS_X;
  }

  void onPlay(Timer timer) {
    // debugPrint('onPlay called ${timer.tick}');
    var status = Collision.NONE;
    setState(() {
      if (action != null && !checkOnEdge(action!)) {
        block?.move(action!);
      }

      for (var oldSubBlock in oldSubBlocks) {
        block?.subBlocks.forEach((subBlock) {
          var x = subBlock.x + block?.x;
          var y = subBlock.y + block?.y;
          if (x == oldSubBlock.x && y == oldSubBlock.y) {
            switch (action) {
              case BlockMovement.LEFT:
                block?.move(BlockMovement.RIGHT);
                break;
              case BlockMovement.RIGHT:
                block?.move(BlockMovement.LEFT);
                break;
              case BlockMovement.ROTATE_CLOCKWISE:
                block?.move(BlockMovement.ROTATE_COUNTER_CLOCKWISE);
                break;
              case BlockMovement.ROTATE_COUNTER_CLOCKWISE:
                block?.move(BlockMovement.ROTATE_CLOCKWISE);
                break;
              default:
                break;
            }
          }
        });
      }

      if (checkAtBottom()) {
        status = Collision.LANDED;
      } else if (checkAboveBlock()) {
        status = Collision.LANDED_BLOCK;
      } else {
        block?.move(BlockMovement.DOWN);
      }

      if (status == Collision.LANDED_BLOCK && (block?.y)! < 0) {
        isGameOver = true;
        endGame();
      } else if (status == Collision.LANDED ||
          status == Collision.LANDED_BLOCK) {
        block?.subBlocks.forEach((subBlock) {
          subBlock.x += block?.x;
          subBlock.y += block?.y;
          oldSubBlocks.add(subBlock);
        });
        block = getNewBlock();
      }

      action = null;
      updateScore();
    });
  }

  void updateScore() {
    var combo = 1;
    Map<int, int> rows = {};
    List<int> rowsToBeRemoved = [];

    for (var subBlock in oldSubBlocks) {
      rows.update(
        subBlock.y,
        (value) => ++value,
        ifAbsent: () => 1,
      );
    }

    rows.forEach((rowNum, count) {
      if (count == BLOCKS_X) {
        Provider.of<Data>(context, listen: false).addScore(combo++);
        rowsToBeRemoved.add(rowNum);
      }
    });

    if (rowsToBeRemoved.isNotEmpty) {
      removeRows(rowsToBeRemoved);
    }
  }

  void removeRows(List<int> rowsToBeRemoved) {
    rowsToBeRemoved.sort();
    for (var rowNum in rowsToBeRemoved) {
      oldSubBlocks.removeWhere((subBlock) => subBlock.y == rowNum);
      for (var subBlock in oldSubBlocks) {
        if (subBlock.y < rowNum) {
          ++subBlock.y;
        }
      }
    }
  }

  void startGame() {
    Provider.of<Data>(context, listen: false).setIsPlaying(true);
    RenderBox renderBoxGame =
        _keyGameArea.currentContext?.findRenderObject() as RenderBox;
    Offset position = renderBoxGame.localToGlobal(Offset.zero);
    debugPrint(
        'renderBoxGame position and size: ${position.dx} - ${position.dy} : ${renderBoxGame.size.width} ${renderBoxGame.size.height}');
    subBlockWidth =
        (renderBoxGame.size.width - GAME_AREA_BORDER_WIDTH * 2) / BLOCKS_X;
    block ??= getNewBlock();
    // debugPrint('subBlockWidth: $subBlockWidth, ${block?.x}-${block?.y}');
    timer = Timer.periodic(duration, onPlay);
  }

  void endGame() {
    Provider.of<Data>(context, listen: false).setIsPlaying(false);
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

    for (var oldSubBlock in oldSubBlocks) {
      subBlocks.add(getPositionedSquareContainer(
          oldSubBlock.color, oldSubBlock.x, oldSubBlock.y));
    }

    if (isGameOver) {
      subBlocks.add(getGameOverRect());
    }

    // debugPrint('drawBlocks: ${subBlocks[0].left}-${subBlocks[0].top}');
    return Stack(
      children: subBlocks,
    );
  }

  Positioned getGameOverRect() {
    return Positioned(
        left: subBlockWidth * 1.0,
        top: subBlockWidth * 6.0,
        child: Container(
          width: subBlockWidth * 8.0,
          height: subBlockWidth * 3.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: const Text(
            'Game Over',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        action =
            details.delta.dx > 0 ? BlockMovement.RIGHT : BlockMovement.LEFT;
      },
      onTap: () {
        action = BlockMovement.ROTATE_CLOCKWISE;
      },
      child: AspectRatio(
        aspectRatio: BLOCKS_X / BLOCKS_Y,
        child: Container(
          key: _keyGameArea,
          decoration: BoxDecoration(
              color: Colors.indigo[800],
              border: Border.all(
                width: GAME_AREA_BORDER_WIDTH,
                color: Colors.indigoAccent,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10.0))),
          child: drawBlocks(),
        ),
      ),
    );
  }
}
