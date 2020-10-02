import 'package:flutter/material.dart';

class DecisionButton extends StatefulWidget {
  final Color color;
  final String text;
  final Icon icon;
  final Function submitDesicion;
  const DecisionButton(
      {Key key,
      this.color,
      @required this.text,
      this.icon,
      this.submitDesicion})
      : super(key: key);
  @override
  _DecisionButton createState() => _DecisionButton();
}

class _DecisionButton extends State<DecisionButton> {
  bool _isSelfPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: _isSelfPressed
              ? [
                  BoxShadow(
                    color: Color.lerp(
                        Colors.black, widget.color ?? Colors.green[300], 1.5),
                    blurRadius: 4.0, // has the effect of softening the shadow
                    spreadRadius: -4, // has the effect of extending the shadow
                  )
                ]
              : []),
      child: RaisedButton(
        child: widget.icon != null ? widget.icon : Icon(Icons.thumb_up),
        onPressed: () {
          widget.submitDesicion();
          setState(() {
            _isSelfPressed = true;
            Future.delayed(Duration(milliseconds: 200), () {
              setState(() {
                _isSelfPressed = false;
              });
            });
          });
        },
        color: widget.color != null ? widget.color : Colors.green[300],
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(100.0),
        ),
      ),
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      height: 70.0,
      width: 70.0,
    );
  }
}
