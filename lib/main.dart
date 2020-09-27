import 'dart:convert';

import 'package:flutter/material.dart';
import 'DraggedCard.dart';
import 'package:http/http.dart' as http;
import 'Models/Question.dart';

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
          title: 'Flutter Demo',
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

class _MyHomePageState extends State<MyHomePage> {
  double wassah = 0.0;
  double respect = 0.0;
  double cash = 0.0;
  double pazam = 0.0; //percent
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('כבוד: ' + this.respect.toString(),
                    style: new TextStyle(fontSize: 20, color: Colors.blue)),
                Text('כסף: ' + this.cash.toString(),
                    style:
                        new TextStyle(fontSize: 20, color: Colors.greenAccent)),
                Text('ווסאח: ' + this.wassah.toString(),
                    style: new TextStyle(fontSize: 20, color: Colors.yellow))
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Fuck()
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
      setState(() {
        text = choice
            ? currentQuestion.confirmImplication.text
            : currentQuestion.rejectImplication.text;
        situation = "implication";
        new Future.delayed(const Duration(seconds: 3), newQuestion);
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
