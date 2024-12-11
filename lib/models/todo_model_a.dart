class TodoModelA {
  int? id;
  String? text;
  bool? isDone;

  TodoModelA();

  factory TodoModelA.fromJson(Map<String, dynamic> json) => TodoModelA()
    ..id = json['id'] as int?
    ..text = json['text'] as String?
    ..isDone = json['isDone'] as bool?;

  factory TodoModelA.fromSqfliteJson(Map<String, dynamic> json) => TodoModelA()
    ..id = json['id'] as int?
    ..text = json['text'] as String?
    ..isDone = (json['isDone'] as int) == 1 ? true : false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isDone': isDone,
    };
  }

  Map<String, dynamic> toSqfliteJson() {
    return {
      'id': id,
      'text': text,
      'isDone': isDone == true ? 1 : 0,
    };
  }
}
