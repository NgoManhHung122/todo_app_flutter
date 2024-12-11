import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:todo_app_flutter/models/todo_model_a.dart';

const String database = "todoDatabaseA.db"; // ten de tham chieu den vung nho
const String todoTable = "todo";

class TodoDatabaseA {
  Future<Database> initializeDB() async {
    String databasesPath = await getDatabasesPath();
    // join path with database name
    String path = p.join(databasesPath, database);

    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE $todoTable(id INTEGER PRIMARY KEY, text TEXT, isDone INTEGER NOT NULL DEFAULT 0 )');
      },
      version: 1,
    );
  }

  // A method that retrieves all the todo list from the todo table
  Future<List<TodoModelA>> getTodoList() async {
    // Get a reference to the database.
    final db = await initializeDB();

    // Query the table for all the todo list
    final List<Map<String, dynamic>> maps = await db.query(todoTable);

    // Convert the List<Map<String, dynamic> to List<TodoModelA>
    // return List.generate(
    //   maps.length,
    //   (idx) => TodoModelA()
    //     ..id = maps[idx]['id']
    //     ..text = maps[idx]['text']
    //     ..isDone = (maps[idx]['isDone'] as int) == 0 ? false : true,
    // );

    return maps.map((e) => TodoModelA.fromSqfliteJson(e)).toList();

    // return List.generate(
    //   maps.length,
    //   (idx) => TodoModelA.fromSqfliteJson(maps[idx]),
    // );
  }

  Future<TodoModelA> insertTodo(TodoModelA todo) async {
    // Get a reference to the database.
    final db = await initializeDB();
    final id = await db.insert(todoTable, todo.toSqfliteJson());
    todo.id = id;
    return todo;
    // return todo..id = id;
  }

  Future<int> updateTodo(TodoModelA todo) async {
    final db = await initializeDB();

    return await db.update(todoTable, todo.toSqfliteJson(),
        where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    final db = await initializeDB();

    return await db.rawDelete(
      'DELETE FROM $todoTable WHERE id = ?',
      [id],
    );
  }
}
