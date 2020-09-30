import 'package:flutter/material.dart';

class DraggedCard extends StatelessWidget {
  DraggedCard(
      {@required this.text,
      @required this.situation,
      @required this.isDragged});

  final text;
  final bool isDragged;
  final situation;
  final themeMap = {
    "implication": {
      "img": AssetImage("assets/images/exclamationMark.png"),
      "color": Colors.yellow[300]
    },
    "question": {
      "img": AssetImage("assets/images/questionMark.png"),
      "color": Colors.blue[300]
    },
    "loading": {
      "img": AssetImage(
        "assets/images/spinner.gif",
      ),
      "color": Colors.green[300]
    },
    "nextCard": {
      "img": AssetImage("assets/images/spinner.gif"),
      "color": Colors.black
    }
  };

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Text('$text',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    fontFamily: "RobotoMono",
                    color: Colors.black),
                maxLines: 5,
                textAlign: TextAlign.center,
                textWidthBasis: TextWidthBasis.longestLine)),
        width: MediaQuery.of(context).size.width - 80,
        height: MediaQuery.of(context).size.height * 0.60,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: themeMap[situation]["color"], width: 4),
          image: DecorationImage(
              image: themeMap[situation]["img"],
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(.06), BlendMode.dstATop),
              fit: BoxFit.cover),
        ));
  }
}
