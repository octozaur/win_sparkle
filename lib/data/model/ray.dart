import 'dart:math';
import 'package:win_test/data/model/circle.dart';

class Ray{
  Ray(this.rad, x, y){
    dots.add(Circle(dotSize, x, y));
    Random rand = Random();
    animatoinType = rand.nextInt(4);
  }
  List<Circle> dots = [];
  int maxSize = 20;
  int size = 0;
  double rad;
  double dotSize = 30;
  late int animatoinType;

  double step = 5;

  void addDot(){
    dots.forEach((e) {
      e.reduceSize();
    });
    if(size < maxSize){
      double x = 0;
      double y = 0;
      if(animatoinType == 0){
        x = dots.last.x + step;
        y = dots.last.y - step;
        //animatoinType = 1;
      } else if(animatoinType == 1){
        x = dots.last.x + step;
        y = dots.last.y + step;
        //animatoinType = 2;
      } else if(animatoinType == 2){
        x = dots.last.x - step;
        y = dots.last.y + step;
        //animatoinType = 3;
      } else if(animatoinType == 3){
        x = dots.last.x - step;
        y = dots.last.y - step;
        //animatoinType = 0;
      }

      //print("x: $x | y: $y");
      dots.add(Circle(dotSize, x, y));
      size++;
    }
  }
}