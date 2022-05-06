import 'dart:math';
import 'package:win_test/data/model/circle.dart';

class Ray{
  Ray(this.dotSize, this.maxSize, this.circleSizeStep, this.step, this.rad, x, y){
    dots.add(Circle(dotSize, x, y));
  }
  List<Circle> dots = [];
  int maxSize;
  double circleSizeStep;
  int size = 0;
  double rad;
  double dotSize = 30;

  double step = 5;

  void addDot(){
    dots.forEach((e) {
      e.reduceSize();
    });
    if(size < maxSize){
      double x = dots.last.x + sin(rad)*step;
      double y = dots.last.y + cos(rad)*step;

      //print("x: $x | y: $y");
      dots.add(Circle(dotSize, x, y, circleSizeStep));
      size++;
    }
  }
}