import "dart:math";
import 'package:flutter/cupertino.dart';

import 'Effect.dart';
import 'package:admatay/Utils/FileHandler.dart';
import 'dart:convert';

class Player {
  String id;
  String name;
  Effect stats;
  double pazam;
  Function setStats;

  Player(
      {int id,
      String name,
      Effect stats,
      @required this.setStats,
      this.pazam}) {
    initStats();
  }

  initStats() {
    stats = new Effect.fromBlank();
    Player.readStatsFromFile().then((statsFromFile) {
      setStats(statsFromFile);
    });
  }

  bool isLost() {
    return this.stats.isContainsNegativeStat();
  }

  static dynamic chooseImplication(List possibleImplications) {
    return possibleImplications[Random().nextInt(possibleImplications.length)];
  }

  static Future<Effect> readStatsFromFile() async {
    FileHandler fileHandler = new FileHandler(fileName: "player.json");
    String content = await fileHandler.readFromFile();
    dynamic statsFromFile;
    if (content.isNotEmpty) {
      //is empty or null
      statsFromFile = json.decode(content);
      statsFromFile = Effect.fromJson(effectMap: statsFromFile);
    } else {
      statsFromFile = Effect.fromBlank();
    }
    return statsFromFile;
  }

  void saveStatsToFile() async {
    String statsJsoned = jsonEncode(this.stats.toJson());
    FileHandler fileHandler = new FileHandler(fileName: "player.json");
    fileHandler.writeToFile(statsJsoned);
  }
}
