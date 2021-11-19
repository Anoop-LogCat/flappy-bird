import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  final String direction;
  const Bird({Key? key, required this.direction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: direction == "UP"
          ? 45.0
          : direction == "DOWN"
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
