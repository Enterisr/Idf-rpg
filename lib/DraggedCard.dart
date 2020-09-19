import 'package:flutter/material.dart';

class DraggedCard extends StatelessWidget {
  DraggedCard({@required this.text, @required this.situation});

  final text;
  final situation;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Text('$text',
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    fontStyle: FontStyle.italic,
                    fontFamily: "RobotoMono",
                    color: Colors.black),
                maxLines: 5,
                textAlign: TextAlign.center,
                textWidthBasis: TextWidthBasis.longestLine)),
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.height * 0.50,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue[300], width: 5),
          image: DecorationImage(
              image: AssetImage("assets/images/questionMark.png"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(.06), BlendMode.dstATop),
              fit: BoxFit.cover),
        ));
  }
}
