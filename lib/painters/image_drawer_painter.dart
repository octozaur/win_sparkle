import 'dart:math';
import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:win_test/config/const.dart';
import 'package:win_test/controller/attachment_controller.dart';
import 'package:win_test/data/model/chase_element.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/color_point.dart';
import 'package:win_test/data/model/dot.dart';
import 'package:win_test/presentation/effects/drawer.dart';

class ImageDrawerPainter extends CustomPainter{
  ImageDrawerPainter({
    //required this.attachmentsController
    required this.colorPoints,
    required this.modeIndex
  });

  List<ColorPoint> colorPoints;
  int modeIndex;
  //AttachmentsController attachmentsController;



  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style=PaintingStyle.fill
    ..blendMode = modes[modeIndex];
    //canvas.drawCircle(Offset(0, 0), 15, paint..color = Colors.red);
    //print(colorPoints.length);
    int j = 0;

    for(int i = 0; i < colorPoints.length; i++){
      j++;
      canvas.drawCircle(Offset(colorPoints[i].x , colorPoints[i].y), colorPoints[i].radius, paint..color=colorPoints[i].color);
    }

    //canvas.save();
    //print(j);
  }

  double lengthBetweenPoints(Offset a, Offset b){
    return sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));
  }


  Color getRGBColor(Circle circle, double maxSize){
    if(circle.size >= maxSize*0.9){
      return const Color(0xffff0000);
    } else if(circle.size < maxSize*0.9 && circle.size >= maxSize*0.8){
      return const Color(0xff00ff00);
    } else if(circle.size < maxSize*0.8 && circle.size >= maxSize*0.7){
      return const Color(0xff0000ff);
    } else if(circle.size < maxSize*0.7 && circle.size >= maxSize*0.6){
      return const Color(0xfffd0000);
    } else if(circle.size < maxSize*0.6 && circle.size >= maxSize*0.5){
      return const Color(0xff00ff00);
    } else if(circle.size < maxSize*0.5 && circle.size >= maxSize*0.4){
      return const Color(0xff0000ff);
    } else if(circle.size < maxSize*0.4 && circle.size >= maxSize*0.3){
      return const Color(0xffff0000);
    } else if(circle.size < maxSize*0.3 && circle.size >= maxSize*0.2){
      return const Color(0xff00ff00);
    } else if(circle.size < maxSize*0.2 && circle.size >= maxSize*0.1){
      return const Color(0xff0000ff);
    } else if(circle.size < maxSize*0.1 && circle.size >= maxSize*0){
      return const Color(0xffff0000);
    }
    return Colors.white;
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
      return const Color(0xff00f742);
    } else if(circle.size < maxSize*0.4 && circle.size >= maxSize*0.3){
      return const Color(0xff00f7c1);
    } else if(circle.size < maxSize*0.3 && circle.size >= maxSize*0.2){
      return const Color(0xff00a1f7);
    } else if(circle.size < maxSize*0.2 && circle.size >= maxSize*0.1){
      return const Color(0xff006ff7);
    } else if(circle.size < maxSize*0.1 && circle.size >= maxSize*0){
      return const Color(0xff006ff7);
    } else if(circle.size < maxSize*0.1 && circle.size >= maxSize*0){
      return const Color(0xff003ef7);
    }
    return Colors.white;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}