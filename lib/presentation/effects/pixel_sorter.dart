import 'dart:io';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:win_test/config/my_colors.dart';
import 'package:win_test/controller/pixel_sorter_controller.dart';
import 'package:win_test/data/model/circle.dart';
import 'package:win_test/painters/pixel_sorter_painter.dart';
import 'package:win_test/presentation/widgets/check_box_setting.dart';
import 'package:win_test/presentation/widgets/slider_setting.dart';

class PixelSorter extends StatefulWidget{
  const PixelSorter({Key? key}) : super(key: key);

  @override
  _PixelSorterState createState() => _PixelSorterState();
}


class _PixelSorterState extends State<PixelSorter>{
  late double x = MediaQuery.of(context).size.width/2;
  late double y = MediaQuery.of(context).size.height/2;

  late PixelSorterController controller;

  double settingsWidth = 400;
  double settingsHeight = 700;
  double controlPanelWidth = 50;
  double originalImageWidth = 0;
  double originalImageHeight = 0;

  double mapImageWidth = 0;
  double mapImageHeight = 0;

  double accentElementSize = 3;

  double resultImageWidth = 0;
  double resultImageHeight = 0;

  double imageBorderHorizontal = 10;
  double imageBorderVertical = 10;

  bool showBrush = false;

  double dotsImageWidth = 0;
  double dotsImageHeight = 0;
  double k = 1;
  bool showOriginalImage = true;
  PixelSortingState state = PixelSortingState.radial;

  double brushSize = 100;
  double maxBrushSize = 305;
  double minBrushSize = 1;
  double brushSizeDelta = 10;
  bool isBrushWhite = true;
  Offset brushOffset = Offset(0, 0);
  List<Circle> drawPoints = [];

  bool mapOriginalMode = false;


  @override
  void initState() {
    controller = PixelSorterController(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(originalImageWidth == 0){
      originalImageWidth = (MediaQuery.of(context).size.width - controlPanelWidth - settingsWidth)/3;
    }
    if(mapImageWidth == 0){
      mapImageWidth = (MediaQuery.of(context).size.width - controlPanelWidth - settingsWidth)/3;
    }
    if(resultImageWidth == 0){
      resultImageWidth = (MediaQuery.of(context).size.width - controlPanelWidth - settingsWidth)/3;
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

              SingleChildScrollView(
                child: Row(
                  children: [
                    if(showOriginalImage)
                      _originalImageContainer(),
                    if(controller.mapFile != null)
                      _mapImageContainer(),
                    if(controller.newFile != null)
                      _resultImage(controller.newFile!)
                  ],
                ),
              ),
              _controlPanel(),
            ],
          )
    );
  }


  Widget _originalImageContainer() => SizedBox(
    width: originalImageWidth,
    height: (controller.maxY*originalImageWidth)/controller.maxX,
    child: Stack(
      children: [

        if(controller.file != null && controller.image != null)
          _originalImage(controller.file!),
        if(state == PixelSortingState.radial)
          Positioned(
            top: (controller.startY*((controller.maxY*originalImageWidth)/controller.maxX))/controller.maxY,
            left: (controller.startX*originalImageWidth)/controller.maxX,
            child: Container(
              width: 15,
              height: 15,
              color: Colors.red,
            ),
          ),
      ],
    ),
  );

  Widget _mapImageContainer() => Listener(
    onPointerHover: (event){
      setState(() {
        brushOffset = event.position;
        if(event.position.dy <= 0 || event.position.dy > (controller.maxY*mapImageWidth)/controller.maxX - 1 || event.position.dx < originalImageWidth - controlPanelWidth + 101 || event.position.dx >= originalImageWidth - controlPanelWidth + 99 + mapImageWidth){
          showBrush = false;
        }else{
          showBrush = true;
        }
      });
    },
    onPointerDown: (event){
      setState(() {
        if(event.buttons == 2){
          isBrushWhite = !isBrushWhite;
        }else if(event.buttons == 1){

          // controller.changeMapImage(isBrushWhite, event.position, brushSize, mapImageWidth, (controller.maxY*mapImageWidth)/controller.maxX).then((value) {setState(() {
          //
          // });});
        }
      });
    },
    onPointerMove: (event){
      setState(() {
        brushOffset = event.position;
        if(event.down && showBrush){
          drawPoints.add(Circle(brushSize, event.position.dx - originalImageWidth - controlPanelWidth, event.position.dy, isWhite: isBrushWhite));
        }
      });
    },
    onPointerSignal: (event){
      setState(() {
        if(event is PointerScrollEvent){
          if(event.scrollDelta.dy < 0){
            if(brushSize < maxBrushSize){
              brushSize += brushSizeDelta;
            }
          }else{
            if(brushSize > minBrushSize){
              if(brushSize - brushSizeDelta > 0){
                brushSize -= brushSizeDelta;
              }else{
                brushSize = 1;
              }
            }
          }
        }
      });
    },
    child: SizedBox(
      width: mapImageWidth,
      height: (controller.maxY*mapImageWidth)/controller.maxX,
      child: Stack(
        children: [

          if(mapOriginalMode)
           _originalImage(controller.file!),
          if(!mapOriginalMode)
            _mapImage(controller.mapFile!),
          SizedBox(
            width: mapImageWidth,
            height: (controller.maxY*mapImageWidth)/controller.maxX,
            child: CustomPaint(
              painter: PixelSorterPainter(points: drawPoints),
            ),
          ),
          if(showBrush)
          Positioned(
              top: brushOffset.dy - brushSize/2,
              left: brushOffset.dx - originalImageWidth - controlPanelWidth - brushSize/2,
              child: Container(
                width: brushSize,
                height: brushSize,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(brushSize)),
                    color: isBrushWhite ? Colors.white: Colors.black
                ),
              )
          ),


        ],
      ),
    ),
  );

  Widget _originalImage(File file) => SizedBox(
      width: controller.image!.width.toDouble() > originalImageWidth ?originalImageWidth : controller.image?.width.toDouble(),
      child: Image.file(file));

  Widget _mapImage(File file) => SizedBox(
      width: controller.image!.width.toDouble() > mapImageWidth ?mapImageWidth : controller.image?.width.toDouble(),
      child: Image.file(file));

  Widget _resultImage(File file) => SizedBox(
      width: controller.image!.width.toDouble() > resultImageWidth ?resultImageWidth : controller.image?.width.toDouble(),
      child: Image.file(file));


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
              controller.pickFile().then((value) async{
                if(state == PixelSortingState.liner){
                  controller.prepareBWImage().then((value) {setState(() {print("ready");});});
                }else{
                  controller.prepareBWImage().then((value) {
                    setState(() {
                      controller.setSizeRange();
                      controller.setStartPointX(0);
                      controller.setStartPointY(0);
                    });
                  });
                  //controller.setStartPoint(x, y)
                }
                //await controller.pixelSortingBubble().then((value) {setState(() {});});
                //await controller.prepareBWImage().then((value) {setState(() {});});
              });
            },),
        CheckBoxSetting(
            title: "Show original image",
            value: showOriginalImage,
            action: (val){setState(() {
              showOriginalImage = val;
            });}
            ),
        _modeSetting(),
        if(state == PixelSortingState.radial)
          _button(
            "Start",
                () async{
                if(drawPoints.isNotEmpty){
                  await controller.addPathToMap(drawPoints, mapImageWidth);
                }
                await controller.pixelSortingQuickRadial().then((value) {setState(() {print("ready");});});
            },),
        if(state == PixelSortingState.radial)
        _button("Center Start", (){setState(() {
          controller.setStartPointX(controller.maxX~/2);
          controller.setStartPointY(controller.maxY~/2);
        });}),
        if(state == PixelSortingState.radial)
        SliderSetting(
            title: "Start X",
            value: controller.startX.toDouble(),
            min: 0,
            max: controller.maxX.toDouble(),
            action: (val){setState(() {
              controller.setStartPointX(val.toInt());
            });}
        ),
        if(state == PixelSortingState.radial)
          SliderSetting(
              title: "Start Y",
              value: controller.startY.toDouble(),
              min: 0,
              max: controller.maxY.toDouble(),
              action: (val){setState(() {
                controller.setStartPointY(val.toInt());
              });}
          ),
        if(state == PixelSortingState.liner)
        Row(
          children: [
            CheckBoxSetting(
                title: "Vertical",
                value: controller.isVertical,
                action: (val){setState(() {
                  controller.setIsVertical(val);
                });}),
            CheckBoxSetting(
                title: "Horizontal",
                value: !controller.isVertical,
                action: (val){setState(() {
                  controller.setIsVertical(!val);
                });}),
          ],
        ),
        Row(
          children: [
            CheckBoxSetting(
                title: "Sort. increase",
                value: controller.sortIncreases,
                action: (val){setState(() {
                  controller.setSortIncrease(val);

                });}),
            CheckBoxSetting(
                title: "Sort. decrease",
                value: !controller.sortIncreases,
                action: (val){setState(() {
                  controller.setSortIncrease(!val);

                });}),
          ],
        ),
        SliderSetting(
            title: "Min brightness",
            value: controller.minBrightness,
            min: 0,
            max: 1,
            action: (val) {
                setState(() {
                  controller.minBrightness = val;
                });
            },
            isInt: false,
        ),
        SliderSetting(
          title: "Max brightness",
          value: controller.maxBrightness,
          min: 0,
          max: 1,
          action: (val) {
            setState(() {
              controller.maxBrightness = val;
            });

          },
          isInt: false,
        ),
        CheckBoxSetting(
            title: "X Mode",
            value: controller.xMode,
            action: (val){setState(() {
              controller.xMode = val;
            });}
            ),
        CheckBoxSetting(
            title: "Original image hint for map",
            value: mapOriginalMode,
            action: (val){setState(() {
              mapOriginalMode = val;
            });}
        ),
        if(state == PixelSortingState.liner)
        _button("Restart", () async{
            if(drawPoints.isNotEmpty){
              await controller.addPathToMap(drawPoints, mapImageWidth);
            }
            await controller.pixelSortingQuick().then((value) {setState(() {print("ready");});});
            //await controller.pixelSortingBubble().then((value) {setState(() {});});
            //await controller.prepareBWImage().then((value) {setState(() {});});

        }),
        _button("Generate Brightness map", () async{

          await controller.prepareBWImage().then((value) {setState(() {

          });});
          //await controller.pixelSortingBubble().then((value) {setState(() {});});
          //await controller.prepareBWImage().then((value) {setState(() {});});

        }),
        _button("Test gen", () async{

          //await controller.prepareBWImage().then((value) {setState(() {});});
            controller.addPathToMap(drawPoints, mapImageWidth);
          //await controller.pixelSortingBubble().then((value) {setState(() {});});
          //await controller.prepareBWImage().then((value) {setState(() {});});

        })
      ],
    ),
  );

  Widget _modeSetting() => Container(
    height: 45,
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        const Text("Mode:  "),
        _modeSettingButton(
            "Liner",
            state == PixelSortingState.liner,
            () => setPixelSortingState(PixelSortingState.liner)
        ),
        _modeSettingButton(
            "Radial",
            state == PixelSortingState.radial,
            () => setPixelSortingState(PixelSortingState.radial)
        ),
      ],
    ),
  );

  void setPixelSortingState(PixelSortingState val){
    state = val;
  }

  Widget _modeSettingButton(String text, bool isActive, Function action) => GestureDetector(
    onTap: (){
      setState(() {
        action();
      });
    },
    child: Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: isActive ? const Color(0xFF4E00FF): const Color(0xFF4C4C4C)
      ),
      child: Center(child: Text(text),),
    ),
  );


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

enum PixelSortingState{
  liner, radial
}

enum ImageDrawerState{
  dotsDrawer, lineDrawer
}



