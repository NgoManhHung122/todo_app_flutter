import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_flutter/models/todo_model.dart';
import 'package:todo_app_flutter/models/todo_model_a.dart';

class AppDialog {
  AppDialog._();

  static void dialog(
    BuildContext context, {
    Widget? title,
    required String content,
    Function()? action,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  content,
                  style: const TextStyle(color: Colors.brown, fontSize: 18.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(fontSize: 16.8),
              ),
              onPressed: () {
                action?.call();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(fontSize: 16.8),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> confirmExitApp(BuildContext context) async {
    bool? status = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('😍'),
        content: const Text(
          'Do you want to exit app?',
          style: TextStyle(color: Colors.brown, fontSize: 18.0),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Yes',
              style: TextStyle(fontSize: 16.8),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: const Text(
              'No',
              style: TextStyle(fontSize: 16.8),
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );

    if (status == true) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  static Future<TodoModel> editTodo(BuildContext context, TodoModel todo) {
    String text = todo.text ?? '';
    TextEditingController editController = TextEditingController(text: text);
    bool textEmpty = text.isEmpty;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setStatus) {
          return AlertDialog(
            title: Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                backgroundColor: Colors.orange.withOpacity(0.8),
                radius: 14.0,
                child: const Icon(Icons.edit, size: 16.0, color: Colors.white),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: editController,
                    onChanged: (value) =>
                        setStatus(() => textEmpty = value.isEmpty),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: textEmpty
                    ? null
                    : () {
                        Navigator.of(context).pop(true);
                      },
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: textEmpty ? Colors.grey : Colors.blue,
                      fontSize: 16.8),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 16.8),
                ),
              ),
            ],
          );
        });
      },
    ).then((value) {
      if (value == true) {
        return todo..text = editController.text.trim();
      }
      return todo;
    });
  }

  static Future<TodoModelA> editTodo2(BuildContext context, TodoModelA todo) {
    String text = todo.text ?? '';
    TextEditingController editController = TextEditingController(text: text);
    bool textEmpty = text.isEmpty;
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setStatus) {
          return AlertDialog(
            title: Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                backgroundColor: Colors.orange.withOpacity(0.8),
                radius: 14.0,
                child: const Icon(Icons.edit, size: 16.0, color: Colors.white),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: editController,
                    onChanged: (value) =>
                        setStatus(() => textEmpty = value.isEmpty),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: textEmpty
                    ? null
                    : () {
                        Navigator.of(context).pop(true);
                      },
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: textEmpty ? Colors.grey : Colors.blue,
                      fontSize: 16.8),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 16.8),
                ),
              ),
            ],
          );
        });
      },
    ).then((value) {
      if (value == true) {
        return todo..text = editController.text.trim();
      }
      return todo;
    });
  }
}
