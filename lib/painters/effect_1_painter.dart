import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/ray.dart';
import 'package:vector_math/vector_math.dart' as vector;

class Effect1Painter extends CustomPainter{
  Effect1Painter({
    required this.x,
    required this.y,
    required this.circles,
    required this.deg,
    required this.rays,
    required this.maxSize,
    required this.sizeChangeStep,
    required this.maxTraceSize,
    required this.displacementChangeStep,
    required this.isRgb
  });

  double x;
  double y;
  List<Circle> circles;
  int deg;
  List<Ray> rays;
  double maxSize;
  double sizeChangeStep;
  int maxTraceSize;
  double displacementChangeStep;
  bool isRgb;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    if(isRgb){
      paint.blendMode = BlendMode.screen;
    }

    List<Circle> tempDeleteC = [];
    List<int> tempDeleteR = [];
    rays.add(Ray(maxSize, maxTraceSize, sizeChangeStep, displacementChangeStep, deg * pi / 180, x, y));
    for(int i = 0; i < rays.length; i++){
      for(int j = 0; j < rays[i].dots.length; j ++){
        canvas.drawCircle(Offset(rays[i].dots[j].x, rays[i].dots[j].y), rays[i].dots[j].size, paint..color=getColor(rays[i].dots[j], rays[i].dotSize));
        if(rays[i].dots[j].size == 0){
          rays[i].dots.removeAt(j);
        }
      }
      rays[i].addDot();
      if(rays[i].dots.isEmpty){
        rays.removeAt(i);
      }
    }

    double circleStartSize = maxSize;
    circles.add(Circle(circleStartSize, x, y, step: sizeChangeStep));
    for(int i = 0; i < circles.length; i++){
      canvas.drawCircle(Offset(circles[i].x, circles[i].y), circles[i].size, paint..color=getColor(circles[i], circleStartSize));
      circles[i].reduceSize();
      if(circles[i].size == 0){
        circles.removeAt(i);
      }
    }

  }

  Color getColor(Circle circle, double maxSize){
    if(circle.size >= maxSize*0.9){
      return const Color(0xfff71000);
    } else if(circle.size < maxSize*0.9 && circle.size >= maxSize*0.8){
      return const Color(0xfff74e00);
    } else if(circle.size < maxSize*0.8 && circle.size >= maxSize*0.7){
      return const Color(0xfff78000);
    } else if(circle.size < maxSize*0.7 && circle.size >= maxSize*0.6){
      return const Color(0xfff7e200);
    } else if(circle.size < maxSize*0.6 && circle.size >= maxSize*0.5){
      return const Color(0xff80f700);
    } else if(circle.size < maxSize*0.5 && circle.size >= maxSize*0.4){
      return const Color(0xff07ff23);
    } else if(circle.size < maxSize*0.4 && circle.size >= maxSize*0.3){
      return const Color(0xff00ffd9);
    } else if(circle.size < maxSize*0.3 && circle.size >= maxSize*0.2){
      return const Color(0xff00c2ff);
    } else if(circle.size < maxSize*0.2 && circle.size >= maxSize*0.1){
      return const Color(0xff0063f7);
    } else if(circle.size < maxSize*0.1 && circle.size >= maxSize*0){
      return const Color(0xff0029f7);
    }
    return Colors.white;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}