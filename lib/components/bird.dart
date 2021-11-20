import 'package:flutter/material.dart';

enum BirdEnum { up, down, rest }

class Bird extends StatelessWidget {
  final BirdEnum direction;
  final double birdYAxis, birdHeight, birdWidth;
  const Bird(
      {Key? key,
      required this.direction,
      required this.birdYAxis,
      required this.birdHeight,
      required this.birdWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdYAxis + birdHeight) / (2 - birdHeight)),
      child: Transform.rotate(
        angle: direction == BirdEnum.up
            ? 45.0
            : direction == BirdEnum.down
                ? -45.0
                : 0,
        child: Image.asset(
          'assets/images/flappy.png',
          width: MediaQuery.of(context).size.height * birdWidth / 2,
          height: MediaQuery.of(context).size.height * 3 / 4 * birdWidth / 2,
        ),
      ),
    );
  }
}
