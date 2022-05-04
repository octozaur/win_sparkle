import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/ray.dart';
import 'package:win_test/painters/effect_1_painter.dart';

class Effect1 extends StatefulWidget {
  const Effect1({Key? key}) : super(key: key);

  @override
  _Effect1State createState() => _Effect1State();
}

class _Effect1State extends State<Effect1> with SingleTickerProviderStateMixin{
  late double x = MediaQuery.of(context).size.width/2;
  late double y = MediaQuery.of(context).size.height/2;
  int deg = 0;
  List<Circle> circles = [];
  List<Ray> rays = [];

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
    if(deg < 360){
      //deg++;
    }else{
      deg = 0;
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
          painter: Effect1Painter(x: x - 50, y: y, circles: circles, deg: deg, rays: rays),
          child: MouseRegion(
            onHover: _updateLocation,
            child: Text("x: $x \n y: $y"),
          ),
        )
    );
  }
}