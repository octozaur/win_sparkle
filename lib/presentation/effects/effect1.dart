import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/data/model/ray.dart';
import 'package:win_test/painters/effect_1_painter.dart';
import 'package:win_test/presentation/widgets/check_box_setting.dart';
import 'package:win_test/presentation/widgets/slider_setting.dart';

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
  int degreeStep = 10;
  double maxSize = 30;
  double sizeChangeStep = 1;
  double displacementChangeStep = 10;
  int maxTraceSize = 10;
  bool isInCenter = false;
  bool isRgb = true;

  late final Ticker _ticker;

  @override
  void initState() {
    _ticker = this.createTicker((elapsed) {
      setState(() {
        if(deg < 360){
          deg = deg + degreeStep;
        }else{
          deg = 0;
        }
      });
    });
    _ticker.start();
    super.initState();
  }
  void _updateLocation(PointerEvent details) {

    if(!isInCenter){
      x = details.position.dx;
      y = details.position.dy;
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
        child: MouseRegion(
          onHover: _updateLocation,
          child: Stack(
            children: [
              // The class that is responsible for drawing the effect
              _painter(),
              // Effect settings control panel
              _controlPanel()
            ],
          ),
        )
    );
  }

  Widget _painter()=>CustomPaint(
    painter: Effect1Painter(
        x: x - 50,
        y: y,
        circles: circles,
        deg: deg,
        rays: rays,
        maxSize: maxSize,
        maxTraceSize: maxTraceSize,
        sizeChangeStep: sizeChangeStep,
        displacementChangeStep: displacementChangeStep,
        isRgb: isRgb
    ),

  );


  Widget _controlPanel()=>Positioned(
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: 400,
        height: 320,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: _settings(),
      )
  );

  Widget _settings() => Scaffold(
    backgroundColor: Colors.transparent,
    body: Column(
      children: [
        SliderSetting(
          title: "Degree change step",
          value: degreeStep.toDouble(),
          min: 1,
          max: 360,
          action: _setDegreeStep
        ),
        SliderSetting(
            title: "Max size",
            value: maxSize,
            min: 1,
            max: 400,
            action: _setMaxSize
        ),
        SliderSetting(
            title: "Size change step",
            value: sizeChangeStep,
            min: 0.1,
            max: 20,
            action: _setSizeChangeStep
        ),
        SliderSetting(
            title: "Max trace size",
            value: maxTraceSize.toDouble(),
            min: 1,
            max: 50,
            action: _setMaxTraceSize
        ),
        SliderSetting(
            title: "Displacement change step",
            value: displacementChangeStep.toDouble(),
            min: 1,
            max: 100,
            action: _setDisplacementChangeStep
        ),
        CheckBoxSetting(
            title: "Set effect in center",
            value: isInCenter,
            action:  _setIsInCenter),
        CheckBoxSetting(
            title: "RGB mode",
            value: isRgb,
            action:  _setRgbMode)
      ],
    ),
  );

  void _setDegreeStep(val){
    degreeStep = val.toInt();
  }

  void _setRgbMode(val){
    isRgb = val;
  }

  void _setMaxSize(val){
    maxSize = val;
  }

  void _setMaxTraceSize(val){
    maxTraceSize = val.toInt();
  }

  void _setDisplacementChangeStep(val){
    displacementChangeStep = val;
  }

  void _setSizeChangeStep(val){
    sizeChangeStep = val;
  }

  void _setIsInCenter(bool val){
    isInCenter = val;
    if(isInCenter == true){
      x = MediaQuery.of(context).size.width/2;
      y = MediaQuery.of(context).size.height/2;
    }
  }
}