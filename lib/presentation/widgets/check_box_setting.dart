import 'package:flutter/material.dart';

class CheckBoxSetting extends StatelessWidget {
  CheckBoxSetting({Key? key,
    required this.title,
    required this.value,
    required this.action
  }) : super(key: key);

  String title;
  bool value;
  Function action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(title, style: const TextStyle(color: Colors.white),),
        ),
        Checkbox(value: value, onChanged: (val){action(val);}, activeColor: const Color(0xFF4E00FF),)
      ],
    );
  }
}
