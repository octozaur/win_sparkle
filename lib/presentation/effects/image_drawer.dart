import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:win_test/config/const.dart';
import 'package:win_test/controller/attachment_controller.dart';
import 'package:win_test/data/model/boundaries.dart';
import 'package:win_test/data/model/chase_element.dart';
import 'package:win_test/data/model/color_point.dart';
import 'package:win_test/data/model/dot.dart';
import 'package:win_test/painters/drawer_painter.dart';
import 'package:win_test/painters/effect_2_painter.dart';
import 'package:win_test/painters/image_drawer_painter.dart';
import 'package:win_test/presentation/widgets/check_box_setting.dart';
import 'package:win_test/presentation/widgets/slider_setting.dart';

class ImageDrawer extends StatefulWidget{
  const ImageDrawer({Key? key}) : super(key: key);

  @override
  _ImageDrawerState createState() => _ImageDrawerState();
}


class _ImageDrawerState extends State<ImageDrawer>{
  late double x = MediaQuery.of(context).size.width/2;
  late double y = MediaQuery.of(context).size.height/2;

  late AttachmentsController attachmentsController;
  List<ColorPoint> colorPoints = [];

  double settingsWidth = 400;
  double settingsHeight = 500;
  double controlPanelWidth = 50;
  double imageWidth = 0;

  double dotsImageWidth = 0;
  double dotsImageHeight = 0;
  double k = 1;
  int modeIndex = 0;
  bool showOriginalImage = true;

  List<ImageDrawerState> states = [
    ImageDrawerState.dotsDrawer,
    ImageDrawerState.lineDrawer
  ];

  int stateIndex = 1;

  @override
  void initState() {
    attachmentsController = AttachmentsController(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(imageWidth == 0){
      imageWidth = (MediaQuery.of(context).size.width - controlPanelWidth - settingsWidth)/2;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black45,
          child: Stack(
            children: [
              // Effect settings control panel

              Row(
                children: [
                  if(showOriginalImage)
                    _imageContainer(),
                  // The class that is responsible for drawing the effect
                  _painter(),
                ],
              ),
              _controlPanel(),
            ],
          )
    );
  }

  Widget _imageContainer() => Column(
    children: [
      if(attachmentsController.file != null && attachmentsController.image != null)
        _image(),
    ],
  );

  Widget _image() => SizedBox(
      width: attachmentsController.image!.width.toDouble() > imageWidth ?(MediaQuery.of(context).size.width - settingsWidth)/2 : attachmentsController.image?.width.toDouble(),
      child: Image.file(attachmentsController.file!));

  Widget _painter()=>Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          if(states[stateIndex] == ImageDrawerState.dotsDrawer)
          CustomPaint(
            painter: ImageDrawerPainter(
                colorPoints: colorPoints,
                modeIndex: modeIndex
            ),
          ),
          if(states[stateIndex] == ImageDrawerState.lineDrawer)
            SizedBox()
        ],
      )
  );


  Widget _controlPanel()=>Positioned(
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: settingsWidth,
        height: settingsHeight,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        _button(
            "Add Image",
            (){
              attachmentsController.pickFile().then((value) {setState(() {
                dotsImageWidth = attachmentsController.image!.width.toDouble() > imageWidth ? imageWidth : attachmentsController.image!.width.toDouble();
                dotsImageHeight = (dotsImageWidth*attachmentsController.image!.height.toDouble())/attachmentsController.image!.width.toDouble();
                k = dotsImageWidth/attachmentsController.image!.width.toDouble();
                draw();
              });});
            },),
        _stateSetting(),
        CheckBoxSetting(
            title: "Show original image",
            value: showOriginalImage,
            action: (val){setState(() {
              showOriginalImage = val;
            });}),
        if(states[stateIndex] == ImageDrawerState.dotsDrawer)
          _settingsDotsDrawer(),
        if(states[stateIndex] == ImageDrawerState.lineDrawer)
          _settingsLinesDrawer(),
      ],
    ),
  );

  Widget _stateSetting() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 20, child: Text("Image drawer algorithm №"),),
      Container(
        padding: const EdgeInsets.all(5),
        width: settingsWidth,
        height: 50,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(states.length, (index) => GestureDetector(
            onTap: (){
              setState(() {
                stateIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: index == stateIndex? Color(0xFF4E00FF): Colors.grey.withOpacity(0.2)
              ),
              child: Center(child: Text("$index"),),
            ),
          )),
        ),
      ),
    ],
  );

  Widget _settingsLinesDrawer()=>Column(
    children: [],
  );

  Widget _settingsDotsDrawer() => Column(
    children: [
      _button(
        "Restart",
            (){
          setState(() {
            draw();
          });
        },),
      SliderSetting(
          title: "Accuracy",
          value: maxDeepness,
          min: 1,
          max: 11,
          action: (val){setState(() {
            maxDeepness = val;
            draw();
          });}
      ),
      SliderSetting(
        title: "Scale",
        value: k,
        min: 0.1,
        max: 1,
        action: (val){setState(() {
          k = val;
          dotsImageWidth = k * attachmentsController.image!.width.toDouble();
          dotsImageHeight = k * attachmentsController.image!.height.toDouble();
          draw();
        });},
        isInt: false,
      ),
      SliderSetting(
        title: "Blending Mode: ${modes[modeIndex]}",
        value: modeIndex.toDouble(),
        min: 0,
        max: 18,
        action: (val){setState(() {
          modeIndex = val.toInt();
          draw();
        });},
      )
    ],
  );



  void draw(){
    //print("--------------start-------------------");
    //print("\nwidth: ${attachmentsController.image!.width.toDouble()} \n height: ${attachmentsController.image!.height.toDouble()}");
    //print("\nwidth: ${dotsImageWidth} \n height: ${dotsImageHeight}");
    colorPoints.clear();
    drawCircle(
        Boundaries(
            x0: 0,
            y0: 0,
            x1: dotsImageWidth,
            y1: dotsImageHeight
        ), 0, k);

    setState(() {

    });

  }

  double maxDeepness = 7;

  void drawCircle(Boundaries boundaries, int deepness, double k){
    //print("##############################################");
    if(deepness < maxDeepness){
      //print("\nx0: ${boundaries.x0}\nx1: ${boundaries.x1}\ny0: ${boundaries.y0}\ny1: ${boundaries.y1}");
      //print("\nwidth: ${boundaries.x1 - boundaries.x0} \n height: ${boundaries.y1 - boundaries.y0}");
      double dx = (boundaries.x1 - boundaries.x0)/2;
      double dy = (boundaries.y1 - boundaries.y0)/2;
      double x = boundaries.x0 + dx;
      double y = boundaries.y0 + dy;
      //print("\nx: $x\ny: $y");
      int d = deepness + 1;
      Color color = attachmentsController.getColor(Offset(x/k, y/k - 50));

        colorPoints.add(ColorPoint(color: color, x: x, y: y, radius: dx > dy ? dy : dx));

      drawCircle(Boundaries(
          x0: boundaries.x0,
          x1: x,
          y0: boundaries.y0,
          y1: y),
          d, k);

      drawCircle(Boundaries(
          x0: x,
          x1: boundaries.x1,
          y0: boundaries.y0,
          y1: y),
          d, k);

      drawCircle(Boundaries(
          x0: boundaries.x0,
          x1: x,
          y0: y,
          y1: boundaries.y1),
          d, k);

      drawCircle(Boundaries(
          x0: x,
          x1: boundaries.x1,
          y0: y,
          y1: boundaries.y1),
          d, k);
    }
  }


  Widget _button(String text, Function action) => InkWell(
    onTap: (){
      action();
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 200,
      height: 40,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color(0xFF4E00FF),
      ),
      child: Center(
        child: Text(text),
      ),
    ),
  );

}

enum ImageDrawerState{
  dotsDrawer, lineDrawer
}



