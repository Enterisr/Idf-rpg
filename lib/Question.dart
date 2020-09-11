class Question {
  String id;
  String text;
  List<Implaction> implications;


  Question({this.id, this.implications, this.text});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json["id"], text: json["text"], implications: json["implications"]);
  }
}
