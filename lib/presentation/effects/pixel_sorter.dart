import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:win_test/controller/pixel_sorter_controller.dart';
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
  double imageWidth = 0;

  double dotsImageWidth = 0;
  double dotsImageHeight = 0;
  double k = 1;
  bool showOriginalImage = true;
  PixelSortingState state = PixelSortingState.radial;


  @override
  void initState() {
    controller = PixelSorterController(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(imageWidth == 0){
      imageWidth = (MediaQuery.of(context).size.width - controlPanelWidth - settingsWidth)/3;
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
                      _imageContainer(),
                    if(controller.bWFile != null)
                      _image(controller.bWFile!),
                    if(controller.newFile != null)
                      _image(controller.newFile!)
                  ],
                ),
              ),
              _controlPanel(),
            ],
          )
    );
  }

  Widget _imageContainer() => Container(
    width: imageWidth,
    height: (controller.maxY*imageWidth)/controller.maxX,
    child: Stack(
      children: [

        if(controller.file != null && controller.image != null)
          _image(controller.file!),
        if(state == PixelSortingState.radial)
          Positioned(
            top: (controller.startY*((controller.maxY*imageWidth)/controller.maxX))/controller.maxY,
            left: (controller.startX*imageWidth)/controller.maxX,
            child: Container(
              width: 15,
              height: 15,
              color: Colors.red,
            ),
          ),
      ],
    ),
  );

  Widget _image(File file) => SizedBox(
      width: controller.image!.width.toDouble() > imageWidth ?imageWidth : controller.image?.width.toDouble(),
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
                  await controller.pixelSortingQuick().then((value) {setState(() {print("ready");});});
                }else{
                  setState(() {
                    controller.setSizeRange();
                    controller.setStartPointX(0);
                    controller.setStartPointY(0);
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
              if(state == PixelSortingState.radial){
                await controller.pixelSortingQuickRadial().then((value) {setState(() {print("ready");});});
              }
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
        _button("Restart", () async{

            await controller.pixelSortingQuick().then((value) {setState(() {print("ready");});});
            //await controller.pixelSortingBubble().then((value) {setState(() {});});
            //await controller.prepareBWImage().then((value) {setState(() {});});

        }),
        _button("Generate BW map", () async{

          await controller.prepareBWImage().then((value) {setState(() {

          });});
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



