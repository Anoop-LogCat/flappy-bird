import 'dart:async';
import 'dart:math';

import 'package:flappybird/components/barrier.dart';
import 'package:flappybird/components/bird.dart';
import 'package:flappybird/components/rock.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isStarted = false;

  double score = 0;
  double highScore = 0;

  double birdYAxis = 0;
  double jumpTime = 0;
  double jumpHeight = 0;
  double jumpSpeed = 2;
  double initialHeight = 0;
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  List<RockModel> rocks = [];
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  resetValues() => setState(() {
        Navigator.pop(context);
        isStarted = false;
        birdYAxis = 0;
        highScore = highScore < score ? score : highScore;
        score = 0;
        jumpHeight = 0;
      });

  setValues() => setState(() {
        isStarted = true;
        jumpTime = 0;
        initialHeight = birdYAxis;
        rocks.clear();
        rocks.add(
            RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));
        rocks.add(
            RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));
        rocks.add(
            RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));
        rocks.add(
            RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));
        rocks.add(
            RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));
        barrierX.clear();
        barrierHeight.clear();
        double x = rand(1.8, 3.0);
        barrierX = [x, x + 1.5];
        barrierHeight = [
          [rand(0.3, 0.8), rand(0.3, 0.8)],
          [rand(0.3, 0.8), rand(0.3, 0.8)],
        ];
      });

  jump() => setState(() {
        jumpTime = 0;
        initialHeight = birdYAxis;
      });

  rockMovement() {
    for (var rock in rocks) {
      rock.dx -= 0.04;
      if (rock.dx < -1.5) {
        rock.dx = 1.5 + rand(0, 1.0);
        rock.dy = rand(-1.0, 1.0);
        rock.width = rand(40, 80);
      }
    }
  }

  barrierMovement() {
    for (int i = 0; i < barrierX.length; i++) {
      setState(() {
        barrierX[i] -= 0.04;
      });
      if (barrierX[i] < -1.8) {
        barrierX[i] = 1.5 + rand(0, 2);
        barrierHeight[i] = [rand(0.3, 0.8), rand(0.3, 0.8)];
      }
    }
  }

  bool birdIsDead() {
    if (birdYAxis < -1 || birdYAxis > 1) {
      return true;
    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdYAxis <= -1 + barrierHeight[i][0] ||
              birdYAxis + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  void start() {
    setValues();
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      rockMovement();
      barrierMovement();
      jumpTime += 0.04;
      if (timer.tick % 5 == 0) {
        score = timer.tick / 5;
      }
      setState(() {
        jumpHeight = (-4.9 * pow(jumpTime, 2)) + (jumpSpeed * jumpTime);
        birdYAxis = initialHeight - jumpHeight;
      });
      if (birdIsDead()) {
        timer.cancel();
        _showDialog();
      }
    });
  }

  BirdEnum direction(double val) => val < 0
      ? BirdEnum.up
      : val > 0
          ? BirdEnum.down
          : BirdEnum.rest;

  double rand(num start, num end) =>
      Random().nextDouble() * (end - start) + start;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => isStarted ? jump() : start(),
      child: Scaffold(
          body: Column(
        children: [playScreen(), scoreScreen(score.toInt(), highScore.toInt())],
      )),
    );
  }

  _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: const Center(
              child: Text(
                "G A M E  O V E R",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetValues,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget playScreen() {
    return Expanded(
      flex: 3,
      child: Container(
        color: Colors.blue,
        child: Center(
          child: Stack(
            children: [
              Bird(
                direction: direction(jumpHeight),
                birdYAxis: birdYAxis,
                birdWidth: birdWidth,
                birdHeight: birdHeight,
              ),
              Barrier(
                barrierX: barrierX[0],
                barrierWidth: barrierWidth,
                barrierHeight: barrierHeight[0][0],
                isThisBottomBarrier: false,
              ),
              Barrier(
                barrierX: barrierX[0],
                barrierWidth: barrierWidth,
                barrierHeight: barrierHeight[0][1],
                isThisBottomBarrier: true,
              ),
              Barrier(
                barrierX: barrierX[1],
                barrierWidth: barrierWidth,
                barrierHeight: barrierHeight[1][0],
                isThisBottomBarrier: false,
              ),
              Barrier(
                barrierX: barrierX[1],
                barrierWidth: barrierWidth,
                barrierHeight: barrierHeight[1][1],
                isThisBottomBarrier: true,
              ),
              Container(
                alignment: const Alignment(0, -0.5),
                child: Text(
                  isStarted ? '' : 'T A P  T O  P L A Y',
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget scoreScreen(int score, int highScore) {
    const textStyle = TextStyle(color: Colors.white, fontSize: 20);
    return Expanded(
        child: Container(
      color: Colors.brown[800],
      child: Stack(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: rocks
                  .map((e) => Rock(
                        dx: e.dx,
                        dy: e.dy,
                        width: e.width,
                      ))
                  .toList()),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "S C O R E\n$score",
                  textAlign: TextAlign.center,
                  style: textStyle,
                ),
                Text("H I G H  S C O R E\n$highScore",
                    textAlign: TextAlign.center, style: textStyle)
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
