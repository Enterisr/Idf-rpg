import "dart:math";
import 'Effect.dart';
import 'package:admatay/Utils/FileHandler.dart';
import 'dart:convert';

class Player {
  String id;
  String name;
  Effect stats;

  Player({int id, String name, Effect stats}) {
    initStats();
  }

  initStats() {
    stats = new Effect(cashEffect: 0, respectEffect: 0, wassahEffect: 0);
    Player.readStatsFromFile().then((statsFromFile) => {stats = statsFromFile});
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
}
