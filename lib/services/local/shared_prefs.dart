import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_flutter/models/todo_model.dart';

class SharedPrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final String keyTodo = 'keyTodo';

  Future<List<TodoModel>?> getTodoList() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString(keyTodo);
    if (data == null) return null;

    print('object $data');

    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;

    print('object $maps');

    return maps.map((e) => TodoModel.fromJson(e)).toList();
  }

  Future<void> saveTodoList(List<TodoModel> todos) async {
    SharedPreferences prefs = await _prefs;
    List<Map<String, dynamic>> maps = todos.map((e) => e.toJson()).toList();
    prefs.setString(keyTodo, jsonEncode(maps));
  }
}
