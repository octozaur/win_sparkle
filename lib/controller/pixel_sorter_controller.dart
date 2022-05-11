
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class PixelSorterController {
  PixelSorterController(this.context);

  late BuildContext context;
  File? file;

  File? newFile;
  File? bWFile;

  img.Image? image;
  img.Image? tempImage;
  Color? color;
  int count = 0;

  int startX = 1;
  int startY = 1;
  int maxX = 1;
  int maxY = 1;

  bool sortIncreases = false;
  bool isVertical = true;

  double minBrightness = 0.1;
  double maxBrightness = 0.7;

  void setSizeRange() {
    maxX = image!.width;
    maxY = image!.height;
  }

  void setStartPointX(int x) {
    startX = x;
  }

  void setStartPointY(int y) {
    startY = y;
  }

  void setIsVertical(bool val){
    isVertical = val;
  }

  void setSortIncrease(bool val){
    sortIncreases = val;
  }

  void close() {
    file?.deleteSync();
  }

  Future pickFile([bool isSolution = false]) async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.image);
    if (result != null) {
      file = File(result.paths[0] ?? "");
      await getImage();
    } else {
      print('Error of picking file: ');
    }
  }

  Future getImage() async{
    Uint8List data;
    try{
      data = await file!.readAsBytes();
      setImageBytes(data);
    }
    catch(ex){
      print(ex.toString());
    }


  }

  void setImageBytes(imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    image = null;
    image = img.decodeImage(values);
  }

  void quickSort(int k, int low, int high){
    if(low < high){
      int pi = partition(k, low, high);

      quickSort(k, low, pi - 1);
      quickSort(k, pi+1, high);
    }
  }

  void quickSortList(List<String> pixelColorMap, int low, int high){
    if(low < high){
      int pi = partitionMap(pixelColorMap, low, high);

      quickSortList(pixelColorMap, low, pi - 1);
      quickSortList(pixelColorMap, pi+1, high);
    }
  }

  int partitionMap(List<String> pixelColorMap, int low, int high){
    int pivot =getBrightnessFromHex(int.parse(pixelColorMap.last.split("|").last));
    int i = low - 1;

    bool condition = true;
    for(int j = low; j <= high - 1; j++){
      count ++;
      //print(sortIncreases);
      condition = getIsIncreaseConditionMap(getBrightnessFromHex(int.parse(pixelColorMap[j].split("|").last)), pivot);
      if(condition){
        i++;
        swapRadial(pixelColorMap[j].split("|").first, pixelColorMap[i].split("|").first);
      }
    }
    swapRadial(pixelColorMap[i+1].split("|").first, pixelColorMap[high].split("|").first);
    return i+1;
  }

  int getBrightnessFromHex(int hex){
    Color color = Color(hex);
    return color.red + color.green + color.blue;
  }

  int partition(int k, int low, int high){
    int pivot = isVertical? getBrightness(k, high): getBrightness(high, k);
    int i = low - 1;

    bool condition = true;
    for(int j = low; j <= high - 1; j++){
      count ++;
      //print(sortIncreases);
      condition = isVertical? getIsIncreaseCondition(k, j, pivot): getIsIncreaseCondition(j, k, pivot);
      if(condition){
        i++;
        isVertical ? swap(k, j, k, i) : swap(j, k, i, k);
      }
    }
    isVertical ? swap(k, i+1, k, high) : swap(i+1, k, high, k);
    return i+1;
  }

  bool getIsIncreaseCondition(int x, int y, int pivot){
    return sortIncreases ? getBrightness(x, y) > pivot: getBrightness(x, y) < pivot;
  }

  bool getIsIncreaseConditionMap(int brightness, int pivot){
    return sortIncreases ? brightness > pivot: brightness < pivot;
  }

  void swap(int x1, int y1, int x2, int y2){
    /*int temp = getColorHex(x1, y1);
    image!.setPixelSafe(x1, y1, getColorHex(x2, y2));
    image!.setPixelSafe(x2, y2, temp);*/

    Color temp = getColor(x1, y1);
    tempImage!.setPixelRgba(x1, y1, getColor(x2, y2).red, getColor(x2, y2).green, getColor(x2, y2).blue);
    tempImage!.setPixelRgba(x2, y2, temp.red, temp.green, temp.blue);
  }

  void swapRadial(String val1, String val2){
    List<String> dVal1 = val1.split(",");
    List<String> dVal2 = val2.split(",");
    Color temp = getColor(int.parse(dVal1[0]), int.parse(dVal1[1]));
    tempImage!.setPixelRgba(int.parse(dVal1[0]), int.parse(dVal1[1]), getColor(int.parse(dVal2[0]), int.parse(dVal2[1])).red, getColor(int.parse(dVal2[0]), int.parse(dVal2[1])).green, getColor(int.parse(dVal2[0]), int.parse(dVal2[1])).blue);
    tempImage!.setPixelRgba(int.parse(dVal2[0]), int.parse(dVal2[1]), temp.red, temp.green, temp.blue);
  }

  int getBrightness(int x, int y){
    Color color = getColor(x, y);
    return color.red + color.green + color.blue;
  }

  Future pixelSortingQuickRadial() async{
    prepareBWImage();
    tempImage = image!.clone();
    int width = tempImage!.width;
    int height = tempImage!.height;
    double x = 0;
    double y = 0;
    double t = 0;
    int k = 0;
    double brightness = 0;
    List<int> tempPixelsMap = [];
    //i -> x ; j -> y
    for(int i = 0; i < height; i++){
      printLog(i, height);
      for(int j = width - 1; j > startX; j--){
        //x = j.toDouble();
        //y = (j*(i - startY) - (width - 1)*(i - startY) + i*(width - 1 - startX))/(width - 1 - startX);
        x = j.toDouble();
        t = (x - width - 1)/(startX - width - 1);
        y = i - (startY - i)*t;
        brightness = getBrightness(x.toInt(), y.toInt())/765;
        if(brightness < maxBrightness && brightness > minBrightness){
          k = j;
          //tempPixelsMap["${x.toInt()},${y.toInt()}"] = getColorHex(x.toInt(), y.toInt());
          tempPixelsMap.add("${x.toInt()},${y.toInt()}|${getColorHex(x.toInt(), y.toInt())}");
          brightness = getBrightness(x.toInt(), y.toInt() + 1)/765;
          if(brightness < maxBrightness && brightness > minBrightness){
            //tempPixelsMap["${x.toInt()},${y.toInt() + 1}"] = getColorHex(x.toInt(), y.toInt() + 1);
            tempPixelsMap.add("${x.toInt()},${y.toInt() + 1}|${getColorHex(x.toInt(), y.toInt()) + 1}");
            while(true){
              if(k-1 > startX){
                x = k-1;
                y = ((k-1)*(i - startY) - (width - 1)*(i - startY) + i*(width - 1 - startX))/(width - 1 - startX);
                brightness = getBrightness(x.toInt(), y.toInt())/765;
                if(brightness < maxBrightness && brightness > minBrightness){
                  k--;
                  //tempPixelsMap["${x.toInt()},${y.toInt()}"] = getColorHex(x.toInt(), y.toInt());
                  tempPixelsMap.add("${x.toInt()},${y.toInt()}|${getColorHex(x.toInt(), y.toInt())}");
                }else{
                  break;
                }

                brightness = getBrightness(x.toInt(), y.toInt() + 1)/765;
                if(brightness < maxBrightness && brightness > minBrightness){
                  //tempPixelsMap["${x.toInt()},${y.toInt() + 1}"] = getColorHex(x.toInt(), y.toInt() + 1);
                  tempPixelsMap.add("${x.toInt()},${y.toInt() + 1}|${getColorHex(x.toInt(), y.toInt()) + 1}");
                }else{
                  break;
                }
              }else{
                break;
              }
            }
            quickSortList(tempPixelsMap, 0, tempPixelsMap.length - 1);
            tempPixelsMap.clear();
            j = k;
          }
          
        }
      }
    }

    String newPath = "D:\\test_images\\new_copy_${DateTime.now().microsecondsSinceEpoch/100}.png";
    print(newPath);
    newFile = await File(newPath).writeAsBytes(img.encodePng(tempImage!));
  }

  void printLog(int i, int height){
    if(i % 100 == 0){
      print(i);
      print(height);
      print("==============");
    }
  }


  Future pixelSortingQuick() async{
    prepareBWImage();
    tempImage = image!.clone();
    int k = 0;
    double tempBrightness = 0;
    int pixel32;
    int hex;
    double brightness;
    print("start");
    print(isVertical);
    int width = isVertical? tempImage!.width : tempImage!.height;
    int height = isVertical? tempImage!.height: tempImage!.width;
    print(width);
    print(height);
    int count = 0;
    for(int i = 0; i < width; i++){
      if(i % 100 == 0){
        print(i);
        print(width);
        print("==============");
      }
      for(int j = 0; j < height; j++){

        double brightness = (isVertical? getBrightness(i, j): getBrightness(j, i))/765;
        if(brightness < maxBrightness && brightness > minBrightness){
          k = j;
          tempBrightness = brightness;

          while(true){
            count++;
            if(k+1 < height){
              brightness = (isVertical? getBrightness(i, k + 1) : getBrightness(k + 1, i))/765;
              if(brightness > maxBrightness || brightness < minBrightness){
                break;
              }else{
                k++;
              }
            }else{
              break;
            }
          }

          quickSort(i, j, k);
          j = k;
        }
      }
    }
    count = 0;
    Random rand = Random();
    //String newPath = file!.path.replaceAll(file!.path.split("/").last, "new_copy_${rand.nextInt(100000)}.png");
    String newPath = "D:\\test_images\\new_copy_${DateTime.now().microsecondsSinceEpoch/100}.png";
    print(newPath);
    newFile = await File(newPath).writeAsBytes(img.encodePng(tempImage!));
  }

  Future pixelSortingBubble() async{
    int k = 0;
    double tempBrightness = 0;
    int pixel32;
    int hex;
    double brightness;
    print("start");
    int width = image!.width;
    int height = image!.height;
    int count = 0;
    for(int i = 0; i < width; i++){
      if(i ~/ 10 == 0){
        print(i);
        print(width);
      }
      for(int j = 0; j < height; j++){
        pixel32 = image!.getPixelSafe(i, j);
        hex = abgrToArgb(pixel32);
        double brightness = (Color(hex).red+Color(hex).green+Color(hex).blue)/765;
        if(brightness < 0.7 && brightness > 0.3){
          k = j;
          tempBrightness = brightness;

          while(true){
            count++;
            if(k+1 < height){
              k++;
              pixel32 = image!.getPixelSafe(i, k);
              hex = abgrToArgb(pixel32);
              brightness = (Color(hex).red+Color(hex).green+Color(hex).blue)/765;
              if(brightness > 0.7 || brightness < 0.3){
                break;
              }
            }else{
              break;
            }
          }

          for(int h = j; h < k; h++){
            for(int g = j; g < k; g++){
              count++;
              int pixel1 = image!.getPixelSafe(i, g);
              int pixel2 = image!.getPixelSafe(i, g+1);
              int hex1 = abgrToArgb(pixel1);
              int hex2 = abgrToArgb(pixel2);
              double brightness1 = (Color(hex1).red+Color(hex1).green+Color(hex1).blue)/765;
              double brightness2 = (Color(hex2).red+Color(hex2).green+Color(hex2).blue)/765;
              if(brightness1 < brightness2){
                image!.setPixelRgba(i, g, Color(hex2).red, Color(hex2).green, Color(hex2).blue);
                image!.setPixelRgba(i, g+1, Color(hex1).red, Color(hex1).green, Color(hex1).blue);
              }
            }
          }
          j = k;
        }
      }
    }
    print(count);
    Random rand = Random();
    print(file!.path);
    //String newPath = file!.path.replaceAll(file!.path.split("/").last, "new_copy_${rand.nextInt(100000)}.png");
    String newPath = "D:\\test_images\\new_copy_${rand.nextInt(100000)}.png";
    print(newPath);
    File(newPath).writeAsBytes(img.encodePng(image!)).then((value) => newFile = value);
  }

  Future prepareBWImage() async{
    img.Image tempImage = image!.clone();
    for(int i = 0; i < tempImage.width; i++){
      for(int j = 0; j < tempImage.height; j++){
        int pixel32 = tempImage.getPixelSafe(i, j);
        int hex = abgrToArgb(pixel32);
        double brightness = (Color(hex).red+Color(hex).green+Color(hex).blue)/765;
        if(brightness > maxBrightness || brightness < minBrightness){
          tempImage.setPixelRgba(i, j, 0, 0, 0);
        }else{
          tempImage.setPixelRgba(i, j, 255, 255, 255);
        }
      }
    }

    //String newPath = file!.path.replaceAll(file!.path.split("/").last, "new_copy_${rand.nextInt(100000)}.png");
    String newPath = "D:\\test_images\\bwmaps\\new_copy_${DateTime.now().microsecondsSinceEpoch}_bw.png";
    bWFile = await File(newPath).writeAsBytes(img.encodePng(tempImage));
  }

  Color getColor(int x, int y){
    int pixel32 = tempImage!.getPixelSafe(x, y);
    int hex = abgrToArgb(pixel32);
    //color = Color(hex);
    return Color(hex);
  }

  int getColorHex(int x, int y){
    int pixel32 = tempImage!.getPixelSafe(x, y);
    return abgrToArgb(pixel32);
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }
}
