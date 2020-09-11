import 'package:flutter/material.dart';
import 'DraggedCard.dart';
import 'package:http/http.dart' as http;
import 'Question.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        backgroundColor: Colors.black,
        visualDensity: VisualDensity.comfortable,
      ),
      home: MyHomePage(title: 'Flutter Dem'),
    );
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
  double pazam = 0.0; //percent
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('פזם',
                style: new TextStyle(fontSize: 30, color: Colors.green)),
            Row(
              children: <Widget>[
                Text('כבוד: ' + this.respect.toString(),
                    style: new TextStyle(fontSize: 20, color: Colors.blue)),
                Text('ווסאח: ' + this.wassah.toString(),
                    style: new TextStyle(fontSize: 20, color: Colors.yellow))
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Fuck()
          ],
        ),
      ),
      backgroundColor: Colors.grey[800],
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

Future<Question> FetchQuestion() async {
  final res = await http.get('http://localhost:6969/newQuestion');
  if (res.statusCode == 200) {
    return Question.fromJson(json.decode(res.body));
  } else {
    throw Exception("can't load questions....");
  }
}

class Fuck extends StatefulWidget {
  @override
  _FuckState createState() => _FuckState();
}

class _FuckState extends State<Fuck> {
  bool isLeft = false;
  Future<Question> currentQuestion;
  int questionCounter = 0;

  void initState() {
    super.initState();
    currentQuestion = FetchQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Draggable(
              child: questionCounter < questions.length - 1
                  ? DraggedCard(
                      isLeft: isLeft, question: questions[questionCounter])
                  : Text("לא נשארו עוד שאלות"),
              feedback: DraggedCard(
                  isLeft: isLeft, question: questions[questionCounter]),
              childWhenDragging: questionCounter < questions.length - 2
                  ? DraggedCard(
                      isLeft: isLeft, question: questions[questionCounter + 1])
                  : Text("לא נשארו עוד שאלות"),
              onDragEnd: (drag) {
                double xPos = drag.offset.dx;
                debugPrint("y offset: " + drag.offset.dy.toString());
                debugPrint("x offset: " + drag.offset.dx.toString());
                if (xPos < -150 || xPos > 150) {
                  setState(() {
                    isLeft = xPos < 10;
                    questionCounter++;
                  });
                }
              }),
          Row(
            children: <Widget>[
              DecisionButton(
                  submitDesicion: () => {
                        setState(() {
                          questionCounter++;
                        })
                      },
                  text: "לע",
                  icon: Icons.thumb_down,
                  color: Colors.red[300]),
              DecisionButton(
                  submitDesicion: () => {
                        setState(() {
                          debugPrint("pressed כעע");
                          questionCounter++;
                        })
                      },
                  text: "כע"),
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
