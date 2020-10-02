import 'dart:async';
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
            CardHandler(
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
