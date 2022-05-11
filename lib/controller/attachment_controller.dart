import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class AttachmentsController {
  AttachmentsController(this.context);

  late BuildContext context;
  File? file;
  img.Image? image;
  Color? color;

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

  Color getColor(Offset point){
    int pixel32 = image!.getPixelSafe(point.dx.toInt(), point.dy.toInt() + 50);
    int hex = abgrToArgb(pixel32);
    color = Color(hex);
    return Color(hex);
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }
}
