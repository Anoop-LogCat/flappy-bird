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
  int diffculty = 1;
  double highScore = 0;
  double birdYAxis = 0;
  double jumpTime = 0;
  double jumpHeight = 0;
  double jumpSpeed = 2;
  double initialHeight = 0;

  List<RockModel> rocks = [];
  List<BarrierModel> barriers = [];

  void resetValues() {
    isStarted = false;
    birdYAxis = 0;
    highScore = score;
    score = 0;
    jumpHeight = 0;
  }

  void setValues() {
    isStarted = true;
    jumpTime = 0;
    initialHeight = birdYAxis;

    rocks.clear();
    rocks.add(RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));
    rocks.add(RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));
    rocks.add(RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));
    rocks.add(RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));
    rocks.add(RockModel(1.5 + rand(-1.0, 1.0), rand(-1.0, 1.0), rand(40, 80)));

    barriers.clear();
    barriers.add(BarrierModel(BarrierEnum.top, 1.9, 150));
    barriers.add(BarrierModel(BarrierEnum.bottom, 1.9, 150));
    barriers.add(BarrierModel(BarrierEnum.top, 3.5, 150));
    barriers.add(BarrierModel(BarrierEnum.bottom, 3.5, 150));
  }

  void jump() {
    setState(() {
      jumpTime = 0;
      initialHeight = birdYAxis;
    });
  }

  void start() {
    setValues();
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      for (var rock in rocks) {
        rock.dx -= 0.04;
        if (rock.dx < -1.5) {
          rock.dx = 1.5 + rand(0, 1.0);
          rock.dy = rand(-1.0, 1.0);
          rock.width = rand(40, 80);
        }
      }
      for (var barrier in barriers) {
        barrier.dx -= 0.04;
        if (barrier.dx < -1.9) {
          barrier.dx = 1.9;
          barrier.height = rand(100, 300);
        }
      }
      jumpTime += 0.04;
      if (timer.tick % 5 == 0) {
        score = timer.tick / 5;
      }
      setState(() {
        jumpHeight = (-4.9 * pow(jumpTime, 2)) + (jumpSpeed * jumpTime);
        birdYAxis = initialHeight - jumpHeight;
      });
      if (birdYAxis >= 1.2 || birdYAxis <= -1.0) {
        resetValues();
        timer.cancel();
      }
    });
  }

  BirdEnum direction(double val) {
    return val < 0
        ? BirdEnum.up
        : val > 0
            ? BirdEnum.down
            : BirdEnum.rest;
  }

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

  Widget playScreen() {
    return Expanded(
        flex: 5,
        child: Stack(
          children: [
            Container(
              alignment: Alignment(0, birdYAxis),
              color: Colors.blue,
              child: Bird(direction: direction(jumpHeight)),
            ),
            for (var e in barriers)
              Barrier(
                position: e.position,
                dx: e.dx,
                height: e.height,
              )
          ],
        ));
  }

  Widget scoreScreen(int score, int highScore) {
    const textStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w900, fontSize: 25);
    return Expanded(
        flex: 2,
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
                      "Score\n$score",
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                    Text("High Score\n$highScore",
                        textAlign: TextAlign.center, style: textStyle)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
