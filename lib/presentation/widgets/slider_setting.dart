import 'package:flutter/material.dart';

class SliderSetting extends StatelessWidget {
  SliderSetting({Key? key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.action,
    this.isInt = true
  }) : super(key: key);

  String title;
  double value;
  double min;
  double max;
  Function(double) action;
  bool isInt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 130,
          child: Text(title, style: TextStyle(color: Colors.white),),
        ),
        Slider(
          onChanged: action,
          value: value,
          min: min,
          max: max,
          activeColor: Color(0xFF4E00FF),
        ),
        SizedBox(
          width: 35,
          child: Text(isInt ?value.toInt().toString() :(((value*10).toInt())/10).toString(), style: TextStyle(color: Colors.white),),
        )
      ],
    );
  }
}
