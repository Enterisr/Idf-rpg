import 'package:flutter/material.dart';
import 'main.dart';

class DraggedCard extends StatefulWidget {
  DraggedCard(
      {@required this.text,
      @required this.situation,
      @required this.isDragged,
      this.cardAlignment,
      this.direction});

  final text;
  final bool isDragged;
  final EdgeInsets cardAlignment;
  final situation;
  final dragState direction;

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
  _DraggedCard createState() => _DraggedCard();
}

class _DraggedCard extends State<DraggedCard> {
  Color resolveColor() {
    if (widget.isDragged) {
      switch (widget.direction) {
        case dragState.right:
          return Colors.greenAccent[200];
        case dragState.left:
          return Colors.redAccent[200];
        default:
          return Colors.white;
      }
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.cardAlignment);
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        margin: widget.cardAlignment,
        curve: Curves.easeInOut,
        child: Center(
            child: Text('${widget.text}',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    decoration: TextDecoration.none,
                    fontFamily: "RobotoMono",
                    color: Colors.black),
                maxLines: 5,
                textAlign: TextAlign.center,
                textWidthBasis: TextWidthBasis.parent)),
        width: MediaQuery.of(context).size.width - 40,
        height: MediaQuery.of(context).size.height * 0.65,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                color: widget.themeMap[widget.situation]["color"],
                spreadRadius: 2)
          ],
          color: resolveColor(),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
              color: widget.themeMap[widget.situation]["color"], width: 2),
          image: DecorationImage(
              image: widget.themeMap[widget.situation]["img"],
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(.06), BlendMode.dstATop),
              fit: BoxFit.cover),
        ));
  }
}
