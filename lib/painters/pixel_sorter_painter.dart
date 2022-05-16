import 'dart:math';
import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:win_test/data/model/chase_element.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/dot.dart';
import 'package:win_test/presentation/effects/drawer.dart';

class PixelSorterPainter extends CustomPainter{
  PixelSorterPainter({
    required this.points,
  });

  List<Circle> points;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    for(int i = 0; i < points.length; i++){
      canvas.drawCircle(Offset(points[i].x, points[i].y), points[i].size/2, paint..color = points[i].isWhite ? Colors.white: Colors.black);
    }

  }

  double lengthBetweenPoints(Offset a, Offset b){
    return sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}