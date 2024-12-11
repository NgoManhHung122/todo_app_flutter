class TodoModel {
  String? id;
  String? text;
  bool? isDone;

  TodoModel();

  // factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel()
  //   ..id = json['id']
  //   ..text = json['text']
  //   ..isDone = json['isDone'];

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    isDone = json['isDone'];
  }

  // factory TodoModel.fromSqfliteJson(Map<String, dynamic> json) => TodoModel()
  //   ..id = json['id'] as String?
  //   ..text = json['text'] as String?
  //   ..isDone = (json['isDone'] as int) == 1 ? true : false;

  TodoModel.fromSqfliteJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    isDone = (json['isDone'] as int) == 1 ? true : false;
  }

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


List<TodoModel> todoListA = [
  TodoModel()
    ..id = '1'
    ..text = 'ngu day'
    ..isDone = false,
  TodoModel()
    ..id = '2'
    ..text = 'tap the duc'
    ..isDone = false,
  TodoModel()
    ..id = '3'
    ..text = 'an sang'
    ..isDone = false,
  TodoModel()
    ..id = '4'
    ..text = 'di den truong'
    ..isDone = false,
  TodoModel()
    ..id = '5'
    ..text = 'hoc Flutter'
    ..isDone = false,
  TodoModel()
    ..id = '6'
    ..text = 've nha'
    ..isDone = false,
  TodoModel()
    ..id = '7'
    ..text = 'nghi trua'
    ..isDone = false,
  TodoModel()
    ..id = '8'
    ..text = 'hoc tieng anh'
    ..isDone = false,
  TodoModel()
    ..id = '9'
    ..text = 'di choi'
    ..isDone = false,
];
