import "dart:math";
import 'Effect.dart';

class Question {
  String id;
  String name;
  Effect stats;

  Question({this.id, this.name, this.stats});

  static dynamic chooseImplication(List possibleImplications) {
    return possibleImplications[Random().nextInt(possibleImplications.length)];
  }
}
