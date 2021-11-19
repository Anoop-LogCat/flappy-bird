import 'dart:async';
import 'dart:math';

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
  double jumpSpeed = 3;
  double initialHeight = 0;

  List<RockModel> rocks = [];

  @override
  void initState() {
    super.initState();
    rocks.add(RockModel(doubleInRange(-1.0, 1.0), doubleInRange(-1.0, 1.0),
        doubleInRange(40, 80)));
    rocks.add(RockModel(doubleInRange(-1.0, 1.0), doubleInRange(-1.0, 1.0),
        doubleInRange(40, 80)));
    rocks.add(RockModel(doubleInRange(-1.0, 1.0), doubleInRange(-1.0, 1.0),
        doubleInRange(40, 80)));
    rocks.add(RockModel(doubleInRange(-1.0, 1.0), doubleInRange(-1.0, 1.0),
        doubleInRange(40, 80)));
    rocks.add(RockModel(doubleInRange(-1.0, 1.0), doubleInRange(-1.0, 1.0),
        doubleInRange(40, 80)));
  }

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
          rock.dx = 1.5 + doubleInRange(0, 1.0);
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
      if (birdYAxis >= 1.0 || birdYAxis <= -1.0) {
        resetValues();
        timer.cancel();
      }
    });
  }

  String direction(double val) {
    return val < 0
        ? "UP"
        : val > 0
            ? "DOWN"
            : "REST";
  }

  double doubleInRange(num start, num end) =>
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
        child: Container(
          alignment: Alignment(0, birdYAxis),
          color: Colors.blue,
          child: Bird(direction: direction(jumpHeight)),
        ));
  }

  double rockXStart = 1.0, rockXEnd = -1.0;

  Widget scoreScreen(int score, int highScore) {
    const textStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w900, fontSize: 25);
    return Expanded(
        flex: 2,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.brown[400]!,
            Colors.brown[700]!,
            Colors.brown[900]!
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
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
