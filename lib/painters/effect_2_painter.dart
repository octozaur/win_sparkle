import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:win_test/data/model/chase_element.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/dot.dart';

class Effect2Painter extends CustomPainter{
  Effect2Painter({required this.x, required this.y, required this.dots, required this.chasers});

  double x;
  double y;
  List<Dot> dots;
  List<ChaseElement> chasers;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    double maxSize = 20;

    double length = 0;
    double maxLength = 50;
    double increaseStep = 0.7;

    for(int i = 0; i < dots.length; i ++){
      length = lengthBetweenPoints(Offset(dots[i].x, dots[i].y), Offset(x, y));
      if(dots[i].isActive){
        if(length <= maxLength){
          dots[i].setIsActiveFalse();
          chasers.add(ChaseElement(dots[i].x, dots[i].y, length));
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
      if(length <= maxSize){
        //chasers[i].trace.removeLast();
        chasers[i].doneIncrement();
      }

      for(int j = 0; j < chasers[i].trace.length; j++){
        chasers[i].trace[j].increaseSize(increaseStep);
        canvas.drawCircle(Offset(chasers[i].trace[j].x, chasers[i].trace[j].y), chasers[i].trace[j].size, paint..color=getColor(chasers[i].trace[j], maxSize));
        if(chasers[i].trace[j].size >= maxSize){
          chasers[i].trace.removeAt(j);
        }
      }

      if(chasers[i].trace.isEmpty){
        chasers.removeAt(i);
      }
    }

    canvas.drawCircle(Offset(x, y), maxSize, paint..color=Color(0xFFAF1106));

  }

  double lengthBetweenPoints(Offset a, Offset b){
    return sqrt(pow(a.dx - b.dx, 2) + pow(a.dy - b.dy, 2));
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