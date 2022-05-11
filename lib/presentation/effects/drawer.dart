import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:win_test/data/model/chase_element.dart';
import 'package:win_test/data/model/dot.dart';
import 'package:win_test/painters/drawer_painter.dart';
import 'package:win_test/painters/effect_2_painter.dart';
import 'package:win_test/presentation/widgets/check_box_setting.dart';
import 'package:win_test/presentation/widgets/slider_setting.dart';

class Drawer extends StatefulWidget{
  const Drawer({Key? key}) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

enum PointState{
  start, middle, end
}

class _DrawerState extends State<Drawer> with SingleTickerProviderStateMixin{
  late double x = MediaQuery.of(context).size.width/2;
  late double y = MediaQuery.of(context).size.height/2;
  bool isMouseDown = false;

  List<Offset> points = [];
  List<double> forces = [];
  double velocity = 0;
  Path path = Path();
  PointState pointState = PointState.middle;


  late final Ticker _ticker;

  @override
  void initState() {

    /*_ticker = createTicker((elapsed) {
      setState(() {
      });
    });
    _ticker.start();*/
    super.initState();
  }
  void _updateLocation(PointerEvent details) {
    if(isMouseDown){
      setState(() {
        x = details.position.dx - 50;
        y = details.position.dy;
        velocity = details.delta.dx.abs() + details.delta.dy.abs();
        points.add(Offset(x, y));
        forces.add(velocity);
      });
      pointState = PointState.middle;
    }
  }

  @override
  void dispose() {
    //_ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _updateLocation,
      onPointerDown: (event) => setState(() {
        setState(() {
          points.clear();
          forces.clear();
          pointState = PointState.start;
          isMouseDown = true;
        });
      }),
      onPointerUp: (event) => setState(() {
        setState(() {
          pointState = PointState.end;
          isMouseDown = false;
        });
      }),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black45,
          child: Stack(
            children: [
              // Effect settings control panel
              _controlPanel(),
              // The class that is responsible for drawing the effect
              _painter(),

            ],
          )
      ),
    );
  }

  Widget _painter()=>GestureDetector(
    child: CustomPaint(
      painter: DrawerPainter(
          points: points,
          point: Offset(x, y),
          velocity: velocity,
          path: path,
          pointState: pointState,
          forces: forces
      ),
    ),
  );


  Widget _controlPanel()=>Positioned(
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: 400,
        height: 470,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: _settings(),
      )
  );

  Widget _settings() => Scaffold(
    backgroundColor: Colors.transparent,
    body: Column(
      children: [

      ],
    ),
  );

}



