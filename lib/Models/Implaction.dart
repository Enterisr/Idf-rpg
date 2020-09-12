import 'Question.dart';

import 'Effect.dart';

class Implication {
  String id;
  Effect effect;
  String text;
  Implication implication;
  int followUpQuestion;

  Implication(
      {this.id,
      this.effect,
      this.text,
      this.implication,
      this.followUpQuestion});

  Implication.onlyText(String text) {}

  factory Implication.fromJson({Map<String, dynamic> json, String text}) {
    if (json != null) {
      Effect effect = Effect(
        cashEffect: json["effect"]["c"],
        wassahEffect: json["effect"]["w"],
        respectEffect: json["effect"]["r"],
      );
      return Implication(
        id: json["id"],
        text: json["text"],
        effect: effect,
        followUpQuestion: json["followUpQuestion"],
        implication: json["implication"] != null
            ? Implication.fromJson(json: json["implication"])
            : null,
      );
    } else {
      return Implication.onlyText(text);
    }
  }
  //TODO:
  Question fetchFollowup() {
    //ask something in the future about this past desicion...
  }
}
