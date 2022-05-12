
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

  bool xMode = false;

  void setSizeRange() {
    maxX = image!.width;
    maxY = image!.height;
  }

  void setStartPointX(int x) {
    print(x);
    startX = x;
  }

  void setStartPointY(int y) {
    print(y);
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

  void quickSortList(List<int> pixelColors, int low, int high){
    if(low < high){
      int pi = partitionList(pixelColors, low, high);

      quickSortList(pixelColors, low, pi - 1);
      quickSortList(pixelColors, pi+1, high);
    }
  }

  int partitionList(List<int> pixelColors, int low, int high){
    int pivot = getBrightnessFromHex(pixelColors[high]);
    int i = low - 1;

    for(int j = low; j <= high - 1; j++){
      count ++;
      //print(sortIncreases);
      if(getIsIncreaseConditionMap(getBrightnessFromHex(pixelColors[j]), pivot)){
        i++;
        swapRadial(pixelColors, i, j);
      }
    }
    swapRadial(pixelColors, i + 1, high);
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

  void swapRadial(List<int> pixelColors, int i, int j){
    int temp = pixelColors[i];
    pixelColors[i] = pixelColors[j];
    pixelColors[j] = temp;
  }

  int getBrightness(int x, int y){
    Color color = getColor(x, y);
    return color.red + color.green + color.blue;
  }

  void setPixel(int x, int y, int hex) {
    if(xMode){
      tempImage!.setPixelSafe(x, y, hex);
    }else{
      Color color = Color(hex);
      tempImage!.setPixelRgba(x.toInt(), y.toInt(), color.red, color.green, color.blue);
    }
  }

  Future pixelSortingQuickRadial() async{
    prepareBWImage();
    tempImage = image!.clone();
    int width = tempImage!.width;
    int height = tempImage!.height;
    double x = 0;
    double y = 0;
    double x1 = 0;
    double y1 = 0;
    double t = 0;
    Random rand = Random();
    int r, g, b;
    int k = 0;
    Color color;
    double brightness = 0;
    List<int> tempPixels = [];
    //i -> x ; j -> y

    int f = 0;
    for(int i = 0; i < height; i++){
      printLog(i, height, 0);
      if(f == 0){
        f = 1;
      }else if(f == 1){
        f = 2;
      }else if(f == 2){
        f = 0;
      }
      for(int j = width - 1; j > startX; j--){
        //x = j.toDouble();
        //y = (j*(i - startY) - (width - 1)*(i - startY) + i*(width - 1 - startX))/(width - 1 - startX);
        x = j.toDouble();
        y = ((x - startX)*(i - startY) + startY*(width - 1 - startX))/(width - 1 - startX);
        // t = (x - startX)/(width - 1 - startX);
        // y = startY - (i - startY)*t;
        brightness = getBrightness(x.toInt(), y.toInt())/765;
        if(tempPixels.isNotEmpty){
          /*if(f == 0){
            tempImage!.setPixelRgba(x.toInt(), y.toInt(), 255, 0, 0);
          }else if(f == 1){
            tempImage!.setPixelRgba(x.toInt(), y.toInt(), 0, 255, 0);
          }else{
            tempImage!.setPixelRgba(x.toInt(), y.toInt(), 0, 0, 255);
          }*/
          setPixel(x.toInt(), y.toInt(), tempPixels.last);
          tempPixels.removeLast();


        }else{
          if(brightness < maxBrightness && brightness > minBrightness){
            k = j;
            //TEST
            // r = rand.nextInt(255);
            // g = rand.nextInt(255);
            // b = rand.nextInt(255);
            // Color tempColor = Color.fromRGBO(r, g, b, 1);
            // tempPixels.add(tempColor.value);

            //original value
            tempPixels.add(getColorHex(x.toInt(), y.toInt()));
            while(true){
              if(k-1 > startX){
                x1 = k-1;
                y1 = ((x1 - startX)*(i - startY) + startY*(width - 1 - startX))/(width - 1 - startX);
                // t = (x1 - startX)/(width - 1 - startX);
                // y1 = startY - (i - startY)*t;

                //remember effect
                //y1 = i - (startY - i)*t;
                brightness = getBrightness(x1.toInt(), y1.toInt())/765;
                if(brightness < maxBrightness && brightness > minBrightness){
                  k--;
                  //TEST
                  //tempPixels.add(tempColor.value);

                  //original value
                  tempPixels.add(getColorHex(x1.toInt(), y1.toInt()));
                }else{
                  break;
                }
              }else{
                break;
              }
            }
            quickSortList(tempPixels, 0, tempPixels.length - 1);
            setPixel(x.toInt(), y.toInt(), tempPixels.last);
            tempPixels.removeLast();
          }
        }
      }
    }

    tempPixels.clear();
    for(int i = 0; i < height; i++){
      printLog(i, height, 1);
      for(int j = 0; j < startX; j++){
        x = j.toDouble();
        y = ((x - startX)*(i - startY) + startY*( - startX))/( - startX);
        brightness = getBrightness(x.toInt(), y.toInt())/765;
        if(tempPixels.isNotEmpty){
          setPixel(x.toInt(), y.toInt(), tempPixels.last);
          tempPixels.removeLast();
        }else{
          if(brightness < maxBrightness && brightness > minBrightness){
            k = j;
            //TEST
            // r = rand.nextInt(255);
            // g = rand.nextInt(255);
            // b = rand.nextInt(255);
            // Color tempColor = Color.fromRGBO(r, g, b, 1);
            // tempPixels.add(tempColor.value);

            //original value
            tempPixels.add(getColorHex(x.toInt(), y.toInt()));
            while(true){
              if(k+1 < startX){
                x1 = k+1;
                y1 = ((x1 - startX)*(i - startY) + startY*( - startX))/( - startX);
                brightness = getBrightness(x1.toInt(), y1.toInt())/765;
                if(brightness < maxBrightness && brightness > minBrightness){
                  k++;
                  //TEST
                  //tempPixels.add(tempColor.value);

                  //original value
                  tempPixels.add(getColorHex(x1.toInt(), y1.toInt()));
                }else{
                  break;
                }
              }else{
                break;
              }
            }
            quickSortList(tempPixels, 0, tempPixels.length - 1);
            setPixel(x.toInt(), y.toInt(), tempPixels.last);
            tempPixels.removeLast();
          }
        }
      }
    }


    tempPixels.clear();
    for(int i = 0; i < width; i++){
      printLog(i, width, 2);
      for(int j = 0; j < startY; j++){
        y = j.toDouble();
        x = ((y)*(startX - i) + i*(startY))/(startY);
        //y = ((x)*(startY - startY) + startY*( - startX))/( - startX);

        // x = j.toDouble();
        //y = ((x - startX)*(i - startY) + startY*( - startX))/( - startX);
        brightness = getBrightness(x.toInt(), y.toInt())/765;
        if(tempPixels.isNotEmpty){
          setPixel(x.toInt(), y.toInt(), tempPixels.last);
          tempPixels.removeLast();
        }else{
          if(brightness < maxBrightness && brightness > minBrightness){
            k = j;
            //TEST
            // r = rand.nextInt(255);
            // g = rand.nextInt(255);
            // b = rand.nextInt(255);
            // Color tempColor = Color.fromRGBO(r, g, b, 1);
            // tempPixels.add(tempColor.value);

            //original value
            tempPixels.add(getColorHex(x.toInt(), y.toInt()));
            while(true){
              if(k+1 < startY){
                y1 = k+1;
                x1 = ((y1)*(startX - i) + i*(startY))/(startY);
                brightness = getBrightness(x1.toInt(), y1.toInt())/765;
                if(brightness < maxBrightness && brightness > minBrightness){
                  k++;
                  //TEST
                  //tempPixels.add(tempColor.value);

                  //original value
                  tempPixels.add(getColorHex(x1.toInt(), y1.toInt()));
                }else{
                  break;
                }
              }else{
                break;
              }
            }
            quickSortList(tempPixels, 0, tempPixels.length - 1);
            setPixel(x.toInt(), y.toInt(), tempPixels.last);
            tempPixels.removeLast();
          }
        }
      }
    }

    tempPixels.clear();
    for(int i = 0; i < width; i++){
      printLog(i, width, 3);
      for(int j = height - 1; j > startY; j--){
        y = j.toDouble();
        x = ((y - height - 1)*(startX - i) + i*(startY - height - 1))/(startY - height - 1);
        brightness = getBrightness(x.toInt(), y.toInt())/765;
        if(tempPixels.isNotEmpty){
          setPixel(x.toInt(), y.toInt(), tempPixels.last);
          tempPixels.removeLast();
        }else{
          if(brightness < maxBrightness && brightness > minBrightness){
            k = j;
            //TEST
            // r = rand.nextInt(255);
            // g = rand.nextInt(255);
            // b = rand.nextInt(255);
            // Color tempColor = Color.fromRGBO(r, g, b, 1);
            // tempPixels.add(tempColor.value);

            //original value
            tempPixels.add(getColorHex(x.toInt(), y.toInt()));
            while(true){
              if(k-1 > startY){
                y1 = k-1;
                x1 = ((y1 - height - 1)*(startX - i) + i*(startY - height - 1))/(startY - height - 1);
                brightness = getBrightness(x1.toInt(), y1.toInt())/765;
                if(brightness < maxBrightness && brightness > minBrightness){
                  k--;
                  //TEST
                  //tempPixels.add(tempColor.value);

                  //original value
                  tempPixels.add(getColorHex(x1.toInt(), y1.toInt()));
                }else{
                  break;
                }
              }else{
                break;
              }
            }
            quickSortList(tempPixels, 0, tempPixels.length - 1);
            setPixel(x.toInt(), y.toInt(), tempPixels.last);
            tempPixels.removeLast();
          }
        }
      }
    }

    String newPath = "D:\\test_images\\new_copy_${DateTime.now().microsecondsSinceEpoch/100}.png";
    print(newPath);
    newFile = await File(newPath).writeAsBytes(img.encodePng(tempImage!));
  }

  void printLog(int i, int height,int iter){
    if(i % 100 == 0){
      print(i);
      print(height);
      print(iter);
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
