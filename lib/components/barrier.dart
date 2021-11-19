import 'dart:math';

import 'package:flutter/material.dart';

enum BarrierEnum { top, bottom }

class BarrierModel {
  double dx;
  double height;
  final BarrierEnum position;
  BarrierModel(this.position, this.dx, this.height);
}

class Barrier extends StatelessWidget {
  final BarrierEnum position;
  final double dx;
  final double height;
  const Barrier(
      {Key? key,
      required this.position,
      required this.dx,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(dx, BarrierEnum.top == position ? -1.0 : 1.0),
      child: Container(
        height: height,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.green[800]!, width: 10),
            borderRadius: BarrierEnum.top == position
                ? const BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0))
                : const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0))),
      ),
    );
  }
}
