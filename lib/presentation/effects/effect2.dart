import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:win_test/data/model/chase_element.dart';
import 'package:win_test/data/model/dot.dart';
import 'package:win_test/painters/effect_2_painter.dart';
import 'package:win_test/presentation/widgets/check_box_setting.dart';
import 'package:win_test/presentation/widgets/slider_setting.dart';

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
  double maxSize = 30;
  double sizeChangeStep = 1;
  double displacementChangeStep = 10;
  int maxTraceSize = 10;
  bool isInCenter = false;
  double dotsStep = 50;
  double attractionRadius = 150;
  double doneRadius = 50;
  int dotsRefresh = 100;
  bool isRgb = true;

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
    if(!isInCenter){
      x = details.position.dx;
      y = details.position.dy;
    }
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
    while(true){
      dots.add(Dot(xPos, yPos, dotsRefresh));
      if(xPos + dotsStep < width){
        xPos += dotsStep;
      }else{
        xPos = 20;
        if(yPos + dotsStep < height){
          yPos += dotsStep;
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
    painter:Effect2Painter(
        x: x - 50,
        y: y,
        chasers: chasers,
        dots: dots,
        maxSize: maxSize,
        maxTraceSize: maxTraceSize,
        attractionRadius: attractionRadius,
        displacementChangeStep: displacementChangeStep,
        sizeChangeStep: sizeChangeStep,
        doneRadius: doneRadius,
        isRgb: isRgb
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
            title: "Distance between the dots",
            value: dotsStep,
            min: 20,
            max: 300,
            action: _setDotsDistance
        ),
        SliderSetting(
            title: "Dots refresh",
            value: dotsRefresh.toDouble(),
            min: 10,
            max: 500,
            action: _setDotsRefresh
        ),
        SliderSetting(
            title: "Displacement change step",
            value: displacementChangeStep.toDouble(),
            min: 1,
            max: 100,
            action: _setDisplacementChangeStep
        ),
        SliderSetting(
            title: "Max size",
            value: maxSize,
            min: 1,
            max: 400,
            action: _setMaxSize
        ),
       SliderSetting(
            title: "Max trace size",
            value: maxTraceSize.toDouble(),
            min: 1,
            max: 50,
            action: _setMaxTraceSize
        ),
        SliderSetting(
            title: "Size change step",
            value: sizeChangeStep,
            min: 0.1,
            max: 20,
            action: _setSizeChangeStep
        ),
        SliderSetting(
            title: "Chase trigger distance",
            value: attractionRadius,
            min: 5,
            max: 1000,
            action: _setAttractionRadius
        ),
        SliderSetting(
            title: "Chase done distance",
            value: doneRadius,
            min: 5,
            max: 500,
            action: _setDoneRadius
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

  void _setMaxTraceSize(val){
    maxTraceSize = val.toInt();
  }

  void _setRgbMode(val){
    isRgb = val;
  }

  void _setDotsDistance(val){
    dots = [];
    dotsStep = val;
    setDotsField();
  }

  void _setMaxSize(val){
    maxSize = val;
  }

  void _setDoneRadius(val){
    doneRadius = val;
  }

  void _setDisplacementChangeStep(val){
    displacementChangeStep = val;
  }

  void _setSizeChangeStep(val){
    sizeChangeStep = val;
  }

  void _setDotsRefresh(val){
    dots = [];
    dotsRefresh = val.toInt();
    setDotsField();
  }

  void _setAttractionRadius(val){
    attractionRadius = val;
  }

  void _setIsInCenter(bool val){
    isInCenter = val;
    if(isInCenter == true){
      x = MediaQuery.of(context).size.width/2;
      y = MediaQuery.of(context).size.height/2;
    }
  }
}



