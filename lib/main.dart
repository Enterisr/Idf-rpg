import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'DraggedCard.dart';
import 'package:http/http.dart' as http;
import 'Models/Question.dart';
import 'Models/Player.dart';
import 'Models/Implaction.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'StatField.dart';

void main() {
  runApp(MyApp());
}

enum dragState { left, right, none }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.card,
        child: MaterialApp(
          title: 'idf_rpg',
          builder: (context, child) {
            return Directionality(
                textDirection: TextDirection.rtl, child: child);
          },
          theme: ThemeData(
            primarySwatch: Colors.green,
            backgroundColor: Colors.black,
            visualDensity: VisualDensity.comfortable,
          ),
          home: MyHomePage(title: 'Flutter Dem'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Player player;
  bool isAnimated = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    player = Player(setStats: (newStats) {
      setState(() {
        player.stats = newStats;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.paused) {
      this.player.saveStatsToFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                StatField(
                  name: "כבוד",
                  value: this.player.stats?.respectEffect,
                  isAnimated: isAnimated,
                  icon: FaIcon(FontAwesomeIcons.handshake,
                      color: Colors.blueAccent),
                ),
                StatField(
                    name: "כסף",
                    icon: FaIcon(FontAwesomeIcons.coins,
                        color: Colors.greenAccent),
                    value: this.player.stats?.cashEffect,
                    isAnimated: isAnimated),
                StatField(
                    name: "ווסאח",
                    value: this.player.stats?.wassahEffect,
                    icon: FaIcon(FontAwesomeIcons.fire, color: Colors.yellow),
                    isAnimated: isAnimated),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Fuck(
                player: player,
                addEffect: (newEffect) => {
                      setState(() {
                        isAnimated = true;
                        player.stats.addEffect(newEffect);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          setState(() {
                            isAnimated = false;
                          });
                        });
                      })
                    })
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}

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
      height: 90.0,
      width: 90.0,
    );
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

class Fuck extends StatefulWidget {
  final Player player;
  final Function addEffect;
  const Fuck({Key key, @required this.player, @required this.addEffect})
      : super(key: key);
  @override
  _FuckState createState() => _FuckState();
}

class _FuckState extends State<Fuck> {
  String situation = "loading"; //implication,question, etc..
  Question currentQuestion = Question(text: '');
  String text = "";
  double directionSum = 0.0;
  StreamController<dragState> dragDirectionStream =
      StreamController<dragState>.broadcast(); //this is a nightmare

  void newQuestion() {
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
                          text: text, situation: situation, isDragged: false),
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
                            madeChoice(true);
                          },
                          text: "כע",
                          icon: new Icon(Icons.thumb_up,
                              color: Colors.green[800]),
                          color: Colors.greenAccent[300]),
                      DecisionButton(
                          submitDesicion: () => {madeChoice(false)},
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
