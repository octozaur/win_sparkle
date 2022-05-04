import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:win_test/data/model/chase_element.dart';
import 'package:win_test/data/model/dot.dart';
import 'package:win_test/painters/effect_2_painter.dart';

class Effect2 extends StatefulWidget{
  const Effect2({Key? key}) : super(key: key);

  @override
  _Effect2State createState() => _Effect2State();
}

class _Effect2State extends State<Effect2> with SingleTickerProviderStateMixin{
  late double x = MediaQuery.of(context).size.width/2;
  late double y = MediaQuery.of(context).size.height/2;

  List<Dot> dots = [];
  List<ChaseElement> chasers = [];

  late final Ticker _ticker;

  @override
  void initState() {

    _ticker = this.createTicker((elapsed) {
      setState(() {
      });
    });
    _ticker.start();
    super.initState();
  }
  void _updateLocation(PointerEvent details) {
    x = details.position.dx;
    y = details.position.dy;
  }

  @override
  void didChangeDependencies() {
    if(dots.isEmpty){
      setDotsField();
    }
    super.didChangeDependencies();
  }

  void setDotsField() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double xPos = 20;
    double yPos = 70;
    double step = 100;
    while(true){
      dots.add(Dot(xPos, yPos));
      if(xPos + step < width){
        xPos += step;
      }else{
        xPos = 20;
        if(yPos + step < height){
          yPos += step;
        }else{
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter:Effect2Painter(x: x - 50, y: y, chasers: chasers, dots: dots),
          child: MouseRegion(
            onHover: _updateLocation,
            child: Text("x: $x \n y: $y"),
          ),
        )
    );
  }
}