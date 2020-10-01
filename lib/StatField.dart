import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatField extends StatelessWidget {
  StatField(
      {@required this.name,
      @required this.value,
      @required this.isAnimated,
      this.icon});

  final String name;
  final int value;
  final FaIcon icon;
  final bool isAnimated;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      icon,
      Center(
        child: AnimatedDefaultTextStyle(
            style: this.isAnimated
                ? TextStyle(fontSize: 18)
                : TextStyle(fontSize: 17),
            duration: const Duration(milliseconds: 100),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(name + ": ", textDirection: TextDirection.rtl),
              Text(value.toString(), textDirection: TextDirection.ltr),
            ])),
      )
    ]));
  }
}
