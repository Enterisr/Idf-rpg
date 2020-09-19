import 'Implaction.dart';
import "dart:math";

class Question {
  String id;
  String text;
  Implication rejectImplication;
  Implication confirmImplication;

  Question(
      {this.id, this.rejectImplication, this.confirmImplication, this.text});

  factory Question.fromJson(Map<String, dynamic> json) {
    dynamic tmp = chooseImplication(json["rejectImplication"]);

    Implication regAns = resolveImplication(tmp);
    tmp = chooseImplication(json["confirmImplication"]);
    Implication conAns = resolveImplication(tmp);

    return Question(
        id: json["id"],
        text: json["text"],
        rejectImplication: regAns,
        confirmImplication: conAns);
  }

  static dynamic chooseImplication(List possibleImplications) {
    return possibleImplications[Random().nextInt(possibleImplications.length)];
  }

  static dynamic resolveImplication(dynamic tmp) {
    if (tmp is String) {
      return Implication.fromJson(text: tmp);
    }
    return Implication.fromJson(json: tmp);
  }
}
