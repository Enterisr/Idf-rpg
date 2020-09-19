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

  factory Implication.fromJson({Map<String, dynamic> json, String text}) {
    if (json != null) {
      Effect effect;
      if (json["effect"] != null) {
        effect = Effect(
          cashEffect: json["effect"]["c"],
          wassahEffect: json["effect"]["w"],
          respectEffect: json["effect"]["r"],
        );
      } else {
        effect = new Effect(cashEffect: 0, respectEffect: 0, wassahEffect: 0);
      }
      return Implication(
        id: json["id"],
        text: json["text"],
        effect: effect,
        followUpQuestion:
            json["implication"] != null ? json["followUpQuestion"] : -1,
        implication: json["implication"] != null
            ? Implication.fromJson(json: json["implication"])
            : null,
      );
    }
    return Implication(
        text: text,
        effect: new Effect(cashEffect: 0, respectEffect: 0, wassahEffect: 0));
  }
}
