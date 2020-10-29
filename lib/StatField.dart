import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StatField extends StatelessWidget {
  StatField(
      {@required this.name,
      @required this.value,
      @required this.isAnimated,
      @required this.effectShift,
      this.icon});

  final String name;
  final int value;
  final FaIcon icon;
  final bool isAnimated;
  final int effectShift;

  TextStyle resolveAnimationStyle() {
    if (isAnimated) {
      if (effectShift > 0) {
        return TextStyle(fontSize: 18, color: Colors.green);
      } else if (effectShift < 0) {
        return TextStyle(fontSize: 18, color: Colors.red);
      }
    }
    return TextStyle(fontSize: 18, color: Colors.white);
  }

  String resolveEffectShiftText() {
    if (effectShift > 0) {
      return "+" + this.effectShift.toString();
    }
    return this.effectShift.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      icon,
      Center(
        child: AnimatedDefaultTextStyle(
            style: resolveAnimationStyle(),
            duration: const Duration(milliseconds: 300),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(name + ": ", textDirection: TextDirection.rtl),
              Text(
                  effectShift != null && effectShift != 0
                      ? resolveEffectShiftText()
                      : value.toString(),
                  textDirection: TextDirection.ltr),
            ])),
      )
    ]));
  }
}
