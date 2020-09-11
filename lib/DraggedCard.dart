import 'package:flutter/material.dart';

class DraggedCard extends StatelessWidget {
  DraggedCard({@required this.isLeft, @required this.question});
  final isLeft;
  final question;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Text('$question',
              style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 40,
                  color: Colors.black87),
              maxLines: 2,
              textWidthBasis: TextWidthBasis.longestLine)),
      width: MediaQuery.of(context).size.width - 50,
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.green[100], width: 1),
          color: Colors.white70,
          borderRadius: BorderRadius.circular(4)),
    );
  }
}
