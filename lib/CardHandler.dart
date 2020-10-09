import 'package:flutter/material.dart';
import 'Models/Question.dart';
import 'Models/Player.dart';
import 'Models/Implaction.dart';
import 'dart:async';
import 'main.dart';
import 'DecisionButton.dart';
import 'DraggedCard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CardHandler extends StatefulWidget {
  final Player player;
  final Function addEffect;
  const CardHandler({Key key, @required this.player, @required this.addEffect})
      : super(key: key);
  @override
  _CardHandlerState createState() => _CardHandlerState();
}

class _CardHandlerState extends State<CardHandler> {
  String situation = "loading"; //implication,question, etc..
  Question currentQuestion = Question(text: '');
  String text = "";
  double directionSum = 0.0;
  EdgeInsets cardAlignment = EdgeInsets.all(0);
  StreamController<dragState> dragDirectionStream =
      StreamController<dragState>.broadcast(); //this is a nightmare

  void newQuestion() {
    if (!widget.player.isLost()) {
      setState(() {
        text = "טוען שאלה";
        situation = "loading";
      });
      fetchQuestion().then((question) => {
            setState(() {
              currentQuestion = question;
              text = currentQuestion.text;
              situation = "question";
            })
          });
    } else {
      setState(() {
        text = 'הפסדת!';
        situation = "implication";
      });
    }
  }

  Future<Question> fetchQuestion() async {
    final res = await http.get('http://192.168.1.16:6969/newQuestion');
    if (res.statusCode == 200) {
      final objFromJson = json.decode(res.body);

      return Question.fromJson(objFromJson);
    } else {
      throw Exception("can't load questions....");
    }
  }

  void initState() {
    super.initState();
    newQuestion();
  }

  void madeChoice(bool choice) {
    if (situation == "question") {
      Implication implication = choice
          ? currentQuestion.confirmImplication
          : currentQuestion.rejectImplication;
      setState(() {
        text = implication.text;
        situation = "implication";
        cardAlignment = EdgeInsets.all(0);
        int wordsNum = text.split(" ").length;
        //this is just the below avg reading speed for an adult
        int delay = (wordsNum / 3).round();
        widget.addEffect(implication.effect);
        new Future.delayed(Duration(seconds: delay), newQuestion);
      });
    } else {
      newQuestion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        //TODO: this is an hackish sulotion
        onPointerUp: (event) => {
              setState(() {
                directionSum = 0;
              })
            },
        onPointerMove: (details) {
          setState(() {
            directionSum += details.delta.dx;
          });
          if (directionSum >= 100) {
            setState(() {
              dragDirectionStream.add(dragState.right);
            });
          } else if (directionSum < -100) {
            setState(() {
              dragDirectionStream.add(dragState.left);
            });
          } else {
            dragDirectionStream.add(dragState.none);
          }
        },
        child: Container(
          child: Column(
            //TODO: this is stupid, make it so it only show once
            children: <Widget>[
              this.situation == "question"
                  ? Draggable(
                      child: DraggedCard(
                          text: text,
                          situation: situation,
                          cardAlignment: cardAlignment,
                          isDragged: false),
                      feedback: StreamBuilder(
                          initialData: dragState.none,
                          stream: dragDirectionStream.stream,
                          builder: (context, snapshot) {
                            return DraggedCard(
                                text: text,
                                situation: situation,
                                isDragged: true,
                                direction: snapshot.data ?? dragState.none);
                          }),
                      childWhenDragging: DraggedCard(
                        text: text,
                        situation: situation,
                        isDragged: false,
                      ),
                      onDragEnd: (drag) {
                        double xPos = drag.offset.dx;
                        if (xPos < -150 || xPos > 150) {
                          madeChoice(xPos > 150);
                        }
                      })
                  : DraggedCard(
                      text: text, situation: situation, isDragged: false),
              Container(
                  child: Row(
                    children: <Widget>[
                      DecisionButton(
                          submitDesicion: () {
                            setState(() {
                              cardAlignment =
                                  EdgeInsets.fromLTRB(1500, 0, 0, 0);
                            });
                            new Future.delayed(const Duration(seconds: 1),
                                () => madeChoice(true));
                          },
                          text: "כע",
                          icon: new Icon(Icons.thumb_up,
                              color: Colors.green[800]),
                          color: Colors.greenAccent[300]),
                      DecisionButton(
                          submitDesicion: () {
                            setState(() {
                              cardAlignment =
                                  EdgeInsets.fromLTRB(0, 0, 1500, 0);
                            });
                            new Future.delayed(const Duration(seconds: 1),
                                () => madeChoice(false));
                          },
                          text: "לע",
                          icon: new Icon(Icons.thumb_down,
                              color: Colors.red[800]),
                          color: Colors.red[400]),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40.0))
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ));
  }
}
