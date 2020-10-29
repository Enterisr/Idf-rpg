import 'dart:async';
import 'package:admatay/Models/Effect.dart';
import 'package:flutter/material.dart';
import 'CardHandler.dart';
import 'Models/Player.dart';
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
  Effect newEffect;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    player = Player(setStats: setPlayerStats);
    super.initState();
  }

  void setPlayerStats(newStats) {
    setState(() {
      player.stats = newStats;
    });
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

  void handleLosing() {
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        this.player =
            Player(setStats: setPlayerStats, toReadStatsFromFile: false);
        this.player.saveStatsToFile();
      });
    });
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
                  value: this.player.stats.respectEffect,
                  isAnimated: isAnimated,
                  effectShift: this?.newEffect?.respectEffect,
                  icon: FaIcon(FontAwesomeIcons.handshake,
                      color: Colors.blueAccent),
                ),
                StatField(
                    name: "כסף",
                    icon: FaIcon(FontAwesomeIcons.coins,
                        color: Colors.greenAccent),
                    value: this.player.stats.cashEffect,
                    effectShift: this?.newEffect?.cashEffect,
                    isAnimated: isAnimated),
                StatField(
                    name: 'ת"ש',
                    value: this.player.stats.tashEffect,
                    effectShift: this?.newEffect?.tashEffect,
                    icon: FaIcon(FontAwesomeIcons.solidSmile,
                        color: Colors.pink[300]),
                    isAnimated: isAnimated),
                StatField(
                    name: 'פז"ם',
                    value: this.player.stats.pazamEffect,
                    effectShift: this?.newEffect?.pazamEffect,
                    icon: FaIcon(FontAwesomeIcons.hourglassHalf,
                        color: Colors.green),
                    isAnimated: isAnimated),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            CardHandler(
                player: player,
                addEffect: (newEffect) => {
                      setState(() {
                        isAnimated = true;
                        player.stats.addEffect(newEffect);
                        this.newEffect = newEffect;
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          setState(() {
                            isAnimated = false;
                            this.newEffect = null;
                          });
                        });

                        if (this.player.isLost()) {
                          handleLosing();
                        }
                      })
                    })
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
