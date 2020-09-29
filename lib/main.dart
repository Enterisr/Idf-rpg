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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: MaterialApp(
          title: 'idf_rpg',
          builder: (context, child) {
            return Directionality(
                textDirection: TextDirection.rtl, child: child);
          },
          theme: ThemeData(
            primarySwatch: Colors.green,
            backgroundColor: Colors.black,
            fontFamily: "openSans",
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
      print("ok2");
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
    print(appState);
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
                        Future.delayed(const Duration(milliseconds: 100), () {
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

class DecisionButton extends StatelessWidget {
  DecisionButton(
      {@required this.text,
      @required this.submitDesicion,
      this.color,
      this.icon});
  Color color;
  String text;
  IconData icon;
  Function submitDesicion;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: this.icon != null ? Icon(this.icon) : Icon(Icons.thumb_up),
        onPressed: this.submitDesicion,
        color: this.color != null ? this.color : Colors.green[300],
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(100.0),
        ),
      ),
      padding: EdgeInsets.all(20.0),
      height: 120.0,
      width: 120.0,
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
  int questionCounter = 0;
  String text = "";
  List<int> questions = [1, 2, 4, 5, 6];

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
    return Container(
      child: Column(
        //TODO: this is stupid, make it so it only show once
        children: <Widget>[
          Draggable(
              child: questionCounter < questions.length - 1
                  ? DraggedCard(text: text, situation: situation)
                  : Text(
                      "לא נשארו עוד שאלות",
                      style: TextStyle(color: Colors.white),
                    ),
              feedback: DraggedCard(text: text, situation: situation),
              childWhenDragging: questionCounter < questions.length - 2
                  ? DraggedCard(
                      text: questions[questionCounter + 1],
                      situation: situation)
                  : Text(
                      "לא נשארו עוד שאלות",
                      style: TextStyle(color: Colors.white),
                    ),
              onDragEnd: (drag) {
                double xPos = drag.offset.dx;
                if (xPos < -150 || xPos > 150) {
                  madeChoice(xPos > 150);
                }
              }),
          Row(
            children: <Widget>[
              DecisionButton(
                  submitDesicion: () => {madeChoice(true)}, text: "כע"),
              DecisionButton(
                  submitDesicion: () => {madeChoice(false)},
                  text: "לע",
                  icon: Icons.thumb_down,
                  color: Colors.red[300]),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }
}
