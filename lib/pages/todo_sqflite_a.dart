import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_flutter/components/app_dialog.dart';
import 'package:todo_app_flutter/components/td_app_bar.dart';
import 'package:todo_app_flutter/components/td_search_box.dart';
import 'package:todo_app_flutter/components/todo_item_a.dart';
import 'package:todo_app_flutter/models/todo_model_a.dart';
import 'package:todo_app_flutter/resources/app_color.dart';
import 'package:todo_app_flutter/services/local/todo_database_a.dart';

class TodoSqfliteA extends StatefulWidget {
  const TodoSqfliteA({super.key, required this.title});

  final String title;

  @override
  State<TodoSqfliteA> createState() => _TodoSqfliteAState();
}

class _TodoSqfliteAState extends State<TodoSqfliteA> {
  TextEditingController searchController = TextEditingController();
  TextEditingController addController = TextEditingController();
  FocusNode addFocus = FocusNode();
  List<TodoModelA> todos = [];
  List<TodoModelA> searchList = [];
  bool showAddBox = false;
  TodoDatabaseA db = TodoDatabaseA();
  bool todoEmpty = false;

  @override
  void initState() {
    super.initState();
    _getTodoList();
  }

  Future<void> _getTodoList() async {
    todos = await db.getTodoList();
    searchList = [...todos];
    todoEmpty = todos.isEmpty;
    setState(() {});
  }

  void _search(String value) {
    value = value.toLowerCase();
    searchList = todos
        .where((e) => (e.text ?? '').toLowerCase().contains(value))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: TdAppBar(
          iconPressed: () {
            AppDialog.dialog(
              context,
              title: const Text('😍'),
              content: 'Do you want to exit app?',
              action: () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            );
          },
          title: widget.title,
          icon: Icon(
            Icons.logout,
            size: 24.0,
            color: AppColor.brown.withOpacity(0.8),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TdSearchBox(
                        controller: searchController,
                        onChanged: _search,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(
                      height: 1.2,
                      thickness: 1.2,
                      indent: 20.0,
                      endIndent: 20.0,
                      color: AppColor.grey,
                    ),
                    Expanded(
                      child: todoEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 90.0),
                                child: Text(
                                  'Add Tasks 😍',
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 24.0),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0)
                                      .copyWith(top: 16.0, bottom: 98.0),
                              itemCount: searchList.length,
                              itemBuilder: (context, index) {
                                TodoModelA todo =
                                    searchList.reversed.toList()[index];
                                return TodoItemA(
                                  todo,
                                  onTap: () async {
                                    todo.isDone = !(todo.isDone ?? false);
                                    await db.updateTodo(todo);
                                    setState(() {});
                                  },
                                  onEdit: () async {
                                    todo = await AppDialog.editTodo2(
                                        context, todo);
                                    await db.updateTodo(todo);
                                    setState(() {});
                                  },
                                  onDelete: () {
                                    AppDialog.dialog(
                                      context,
                                      title: const Text('😐'),
                                      content: 'Delete this todo?',
                                      action: () async {
                                        todos.removeWhere(
                                            (e) => e.id == todo.id);
                                        searchList.removeWhere(
                                            (e) => e.id == todo.id);
                                        await db.deleteTodo(todo.id ?? 0);
                                        todoEmpty = todos.isEmpty;
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 20.0),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20.0,
              right: 20.0,
              bottom: 20.0,
              child: Row(
                children: [
                  Expanded(
                    child: Visibility(
                      visible: showAddBox,
                      child: _addBox(),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  _addButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addButton() {
    return GestureDetector(
      onTap: () async {
        if (showAddBox == false) {
          showAddBox = true;
          setState(() {});
          addFocus.requestFocus();
        } else {
          String text = addController.text.trim();
          if (text.isEmpty) {
            showAddBox = false;
            setState(() {});
            addFocus.unfocus();
          } else {
            TodoModelA todo = TodoModelA()
              ..text = text
              ..isDone = false;
            TodoModelA newTodo = await db.insertTodo(todo);
            todos.add(newTodo);
            searchList = [...todos];
            // _search('');
            todoEmpty = todos.isEmpty;
            addController.clear();
            searchController.clear();
            showAddBox = false;
            setState(() {});
            addFocus.unfocus();
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: AppColor.orange,
          border: Border.all(color: AppColor.red, width: 1.2),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          boxShadow: const [
            BoxShadow(
              color: AppColor.shadow,
              offset: Offset(0.0, 3.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: const Icon(Icons.add, size: 32.6, color: AppColor.white),
      ),
    );
  }

  Widget _addBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(color: AppColor.orange, width: 1.2),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        boxShadow: const [
          BoxShadow(
            color: AppColor.shadow,
            offset: Offset(0.0, 3.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TextField(
        controller: addController,
        focusNode: addFocus,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Add a new todo item',
          hintStyle: TextStyle(color: AppColor.grey),
        ),
      ),
    );
  }
}
