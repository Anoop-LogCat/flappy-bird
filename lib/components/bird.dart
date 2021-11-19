import 'package:flutter/material.dart';

enum BirdEnum { up, down, rest }

class Bird extends StatelessWidget {
  final BirdEnum direction;
  const Bird({Key? key, required this.direction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: direction == BirdEnum.up
          ? 45.0
          : direction == BirdEnum.down
              ? -45.0
              : 0,
      child: Image.asset(
        'assets/images/flappy.png',
        width: 50,
        height: 50,
      ),
    );
  }
}
