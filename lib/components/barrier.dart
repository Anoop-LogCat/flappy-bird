import 'dart:math';

import 'package:flappybird/components/height.dart';
import 'package:flutter/material.dart';

enum BarrierEnum { top, bottom }

class BarrierModel {
  double dx;
  double dy;
  final BarrierEnum position;
  BarrierModel(this.position, this.dx, this.dy);
}

class Barrier extends StatelessWidget {
  final BarrierEnum position;
  final double dx;
  final double dy;
  const Barrier(
      {Key? key, required this.position, required this.dx, required this.dy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxHeight = (70 * MediaQuery.of(context).size.height) / 100;
    return Container(
      alignment: Alignment(dx, BarrierEnum.top == position ? -1.0 : 1.0),
      child: Container(
        height: barrierHeight(dy, maxHeight),
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
