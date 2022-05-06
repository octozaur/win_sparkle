import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:win_test/data/model/chase_element.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/dot.dart';

class Effect2Painter extends CustomPainter{
  Effect2Painter({required this.x,
    required this.y,
    required this.dots,
    required this.chasers,
    required this.maxSize,
    required this.sizeChangeStep,
    required this.displacementChangeStep,
    required this.maxTraceSize,
    required this.attractionRadius,
    required this.doneRadius,
    required this.isRgb
  });

  double x;
  double y;
  List<Dot> dots;
  List<ChaseElement> chasers;

  double maxSize;
  double sizeChangeStep;
  double displacementChangeStep;
  int maxTraceSize;
  double attractionRadius;
  double doneRadius;
  bool isRgb;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    if(isRgb){
      paint.blendMode = BlendMode.screen;
    }

    double length = 0;
    double maxLength = attractionRadius;
    double increaseStep = sizeChangeStep;

    for(int i = 0; i < dots.length; i ++){
      length = lengthBetweenPoints(Offset(dots[i].x, dots[i].y), Offset(x, y));
      if(dots[i].isActive){
        if(length <= maxLength){
          dots[i].setIsActiveFalse();
          chasers.add(ChaseElement(dots[i].x, dots[i].y, length, displacementChangeStep, ));
        }else{
          canvas.drawCircle(Offset(dots[i].x, dots[i].y), dots[i].size, paint);
        }
      }else{
        dots[i].incrementRefreshCount();
      }
      //print("${dots[i].x}, ${dots[i].y}");
    }

    //print(chasers.length);

    for(int i = 0; i < chasers.length; i++){

      //print("${chasers[i].trace.last.x} || $x\n${chasers[i].trace.last.y} || $y");

      /*if((chasers[i].trace.last.x + maxSize/2 >= x && chasers[i].trace.last.x - maxSize/2 <= x) && (chasers[i].trace.last.y + maxSize/2 >= y && chasers[i].trace.last.y - maxSize/2 <= y )){
        chasers[i].done = true;
      }*/

      if(!chasers[i].done){
        chasers[i].addCircleToTrace(x, y, maxSize);
      }
      length = lengthBetweenPoints(Offset(chasers[i].trace.last.x, chasers[i].trace.last.y), Offset(x, y));
      if(length <= doneRadius){
        //chasers[i].trace.removeLast();
        chasers[i].doneIncrement();
      }

      for(int j = 0; j < chasers[i].trace.length; j++){
        chasers[i].trace[j].increaseSize(increaseStep);
        canvas.drawCircle(Offset(chasers[i].trace[j].x, chasers[i].trace[j].y), chasers[i].trace[j].size, paint..color= getColor(chasers[i].trace[j], maxSize));
        if(chasers[i].trace[j].size >= maxSize){
          chasers[i].trace.removeAt(j);
        }
      }

      if(chasers[i].trace.isEmpty){
        chasers.removeAt(i);
      }
    }

    canvas.drawCircle(Offset(x, y), 5, paint..color=Color(0xFFAF1106));
    canvas.drawCircle(Offset(x, y), doneRadius, paint..color=Color(0xFF062BAF)..style=PaintingStyle.stroke..strokeWidth=1);
    canvas.drawCircle(Offset(x, y), attractionRadius, paint..color=Color(0xFFAF1106)..style=PaintingStyle.stroke..strokeWidth=1);

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