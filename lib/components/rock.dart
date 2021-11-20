import 'package:flutter/material.dart';

class RockModel {
  double dx;
  double dy;
  double width;
  RockModel(this.dx, this.dy, this.width);
}

class Rock extends StatelessWidget {
  final double dx;
  final double dy;
  final double width;
  const Rock(
      {Key? key, required this.dx, required this.dy, required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(dx, dy),
      child: Container(
        width: width,
        height: 20,
        decoration: BoxDecoration(
            color: Colors.brown, borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
