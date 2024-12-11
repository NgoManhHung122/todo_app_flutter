import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:todo_app_flutter/models/todo_model.dart';

const String database = "todoDatabase.db"; // ten de tham chieu den vung nho
const String todoTable = "todo";

class TodoDatabase {
  Future<Database> initializeDB() async {
    String databasesPath = await getDatabasesPath();
    // join path with database name
    String path = p.join(databasesPath, database);

    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE $todoTable(id TEXT, text TEXT, isDone INTEGER NOT NULL DEFAULT 0 )');
      },
      version: 1,
    );
  }

  // A method that retrieves all the todo list from the todo table
  Future<List<TodoModel>> getTodoList() async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Query the table for all the todo list
    final List<Map<String, dynamic>> maps = await db.query(todoTable);

    // Convert the List<Map<String, dynamic> to List<TodoModel>
    // return List.generate(
    //   maps.length,
    //   (idx) => TodoModel()
    //     ..id = maps[idx]['id']
    //     ..text = maps[idx]['text']
    //     ..isDone = (maps[idx]['isDone'] as int) == 0 ? false : true,
    // );

    List<TodoModel> todos =
        maps.map((e) => TodoModel.fromSqfliteJson(e)).toList();
    return todos;

    // return List.generate(
    //   maps.length,
    //   (idx) => TodoModel.fromSqfliteJson(maps[idx]),
    // );
  }

  Future<void> insertTodo(TodoModel todo) async {
    // Get a reference to the database.
    final db = await initializeDB();
    Map<String, dynamic> map = todo.toSqfliteJson();
    db.insert(todoTable, map);
  }

  Future<void> updateTodo(TodoModel todo) async {
    final db = await initializeDB();

    Map<String, dynamic> map = todo.toSqfliteJson();

    db.update(todoTable, map, where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<void> deleteTodo(String id) async {
    final db = await initializeDB();

    db.rawDelete(
      'DELETE FROM $todoTable WHERE id = ?',
      [id],
    );
  }
}
