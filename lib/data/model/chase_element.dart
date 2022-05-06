import 'dart:math';

import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/dot.dart';

class ChaseElement{
  ChaseElement(x, y, this.maxLength, this.step) : trace = [Circle(1, x, y)];

  late List<Circle> trace;
  double maxLength;
  double step = 10;
  int doneCondition = 5;
  int doneCount = 0;
  bool done = false;

  void addCircleToTrace(double xb, double yb, double maxSize){
    double xa = trace.last.x;
    double ya = trace.last.y;
    double length = sqrt(pow(xa - xb, 2) + pow(ya - yb, 2));
    double t = step/length;
    double x = (1 - t)*xa + t*xb;
    double y = (1 - t)*ya + t*yb;
    double size = Dot(0, 0, 0).size;
    trace.add(Circle(size, x, y));
  }

  void doneIncrement(){
    doneCount++;
    if(doneCount>=doneCondition){
      done = true;
    }
  }
}