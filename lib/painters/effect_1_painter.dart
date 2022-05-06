import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/ray.dart';
import 'package:vector_math/vector_math.dart' as vector;

class Effect1Painter extends CustomPainter{
  Effect1Painter({required this.x, required this.y, required this.circles, required this.deg, required this.rays});

  double x;
  double y;
  List<Circle> circles;
  int deg;
  List<Ray> rays;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    List<Circle> tempDeleteC = [];
    List<int> tempDeleteR = [];
    rays.add(Ray(tan(vector.radians(deg.toDouble())), x, y));
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
    /*rays.asMap().forEach((key, e) {
      e.dots.forEach((k) {
        canvas.drawCircle(Offset(k.x, k.y), k.size, paint..color=getColor(k, e.dotSize));
        *//*if(k.size == 0){
         tempDeleteC.add(k);
        }*//*
      });
      e.addDot();
      *//*tempDeleteC.forEach((a) {
        e.dots.remove(a);
      });
      tempDeleteC = [];
      if(e.dots.length == 0){
        tempDeleteR.add(key);
      }*//*
    });*/
    /*tempDeleteR.forEach((e) {
      rays.removeAt(e);
    });
    tempDeleteC = [];*/
    double circleStartSize = 40;
    circles.add(Circle(circleStartSize, x, y));
    for(int i = 0; i < circles.length; i++){
      canvas.drawCircle(Offset(circles[i].x, circles[i].y), circles[i].size, paint..color=getColor(circles[i], circleStartSize));
      circles[i].reduceSize();
      if(circles[i].size == 0){
        circles.removeAt(i);
      }
    }
/*    circles.forEach((e) {
      canvas.drawCircle(Offset(e.x, e.y), e.size, paint..color=getColor(e, circleStartSize));
      e.reduceSize();
      *//*if(e.size == 0){
        tempDeleteC.add(e);
      }*//*
    });*/
    /*tempDeleteC.forEach((e) {
      circles.remove(e);
    });*/

  }

  Color getColor(Circle circle, double maxSize){
    if(circle.size <= maxSize && circle.size >= maxSize*0.9){
      return const Color(0xfff71000);
    } else if(circle.size < maxSize*0.9 && circle.size >= maxSize*0.8){
      return const Color(0xfff74e00);
    } else if(circle.size < maxSize*0.8 && circle.size >= maxSize*0.7){
      return const Color(0xfff78000);
    } else if(circle.size < maxSize*0.7 && circle.size >= maxSize*0.6){
      return const Color(0xfff7e200);
    } else if(circle.size < maxSize*0.6 && circle.size >= maxSize*0.5){
      return const Color(0xffdef700);
    } else if(circle.size < maxSize*0.5 && circle.size >= maxSize*0.4){
      return const Color(0xff80f700);
    } else if(circle.size < maxSize*0.4 && circle.size >= maxSize*0.3){
      return const Color(0xff00f742);
    } else if(circle.size < maxSize*0.3 && circle.size >= maxSize*0.2){
      return const Color(0xff00f7c1);
    } else if(circle.size < maxSize*0.2 && circle.size >= maxSize*0.1){
      return const Color(0xff00caf7);
    } else if(circle.size < maxSize*0.1 && circle.size >= maxSize*0){
      return const Color(0xff006ff7);
    }
    return Colors.white;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}