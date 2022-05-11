import 'dart:math';
import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:win_test/data/model/chase_element.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/dot.dart';
import 'package:win_test/presentation/effects/drawer.dart';

class DrawerPainter extends CustomPainter{
  DrawerPainter({
    required this.points,
    required this.point,
    required this.velocity,
    required this.path,
    required this.pointState,
    required this.forces
  });

  Offset point;
  List<Offset> points;
  double velocity;
  Path path;
  PointState pointState;
  List<double> forces;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style=PaintingStyle.stroke
      ..blendMode = BlendMode.screen;

/*    if(pointState == PointState.start){
      //path.moveTo(point.dx, point.dy);
    }else if(pointState == PointState.middle){
      path.lineTo(point.dx, point.dy);
    }else if(pointState == PointState.end){
      path.moveTo(point.dx, point.dy);
      //path.close();
    }*/


/*    if(points.length == 1){
      path.moveTo(points.last.dx, points.last.dy);
    }else{
      for(int i = 1; i < points.length; i++){
        path.lineTo(points[i].dx, points[i].dy);
        //canvas.drawLine(points[i][j], points[i][j + 1], paint);
      }
    }*/

    for(int i = 0; i < points.length - 1; i++){
      double disp = forces[i]/4;
      canvas.drawLine(Offset(points[i].dx + disp, points[i].dy + disp), Offset(points[i + 1].dx + disp, points[i + 1].dy + disp), paint..color=Colors.red..strokeWidth = forces[i]);
      canvas.drawLine(Offset(points[i].dx, points[i].dy), Offset(points[i + 1].dx, points[i + 1].dy), paint..color=Colors.green..strokeWidth = forces[i]);
      canvas.drawLine(Offset(points[i].dx - disp, points[i].dy - disp), Offset(points[i + 1].dx - disp, points[i + 1].dy - disp), paint..color=Colors.blue..strokeWidth = forces[i]);
    }


    //canvas.drawPoints(PointMode.points, points, paint);
    /*canvas.drawCircle(Offset(x, y), 5, paint..color=Color(0xFFAF1106));
    canvas.drawCircle(Offset(x, y), doneRadius, paint..color=Color(0xFF062BAF)..style=PaintingStyle.stroke..strokeWidth=1);
    canvas.drawCircle(Offset(x, y), attractionRadius, paint..color=Color(0xFFAF1106)..style=PaintingStyle.stroke..strokeWidth=1);*/

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