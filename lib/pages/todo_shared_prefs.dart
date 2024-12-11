import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_flutter/components/app_dialog.dart';
import 'package:todo_app_flutter/components/td_app_bar.dart';
import 'package:todo_app_flutter/components/td_search_box.dart';
import 'package:todo_app_flutter/components/todo_item.dart';
import 'package:todo_app_flutter/models/todo_model.dart';
import 'package:todo_app_flutter/resources/app_color.dart';
import 'package:todo_app_flutter/services/local/shared_prefs.dart';

class TodoSharedPrefs extends StatefulWidget {
  const TodoSharedPrefs({super.key, required this.title});

  final String title;

  @override
  State<TodoSharedPrefs> createState() => _TodoSharedPrefsState();
}

class _TodoSharedPrefsState extends State<TodoSharedPrefs> {
  TextEditingController searchController = TextEditingController();
  TextEditingController addController = TextEditingController();
  FocusNode addFocus = FocusNode();
  SharedPrefs prefs = SharedPrefs();
  List<TodoModel> todos = [];
  List<TodoModel> searchList = [];
  bool showAddBox = false;

  @override
  void initState() {
    super.initState();
    _getTodoList();
  }

  void _getTodoList() {
    prefs.getTodoList().then((value) {
      todos = value ?? [...todoListA];
      searchList = [...todos];
      setState(() {});
    });
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
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0)
                            .copyWith(top: 16.0, bottom: 98.0),
                        itemCount: searchList.length,
                        itemBuilder: (context, index) {
                          TodoModel todo = searchList.reversed.toList()[index];
                          return TodoItem(
                            todo,
                            onTap: () async {
                              todo.isDone = !(todo.isDone ?? false);
                              await prefs.saveTodoList(todos);
                              setState(() {});
                            },
                            onEdit: () async {
                              todo = await AppDialog.editTodo(context, todo);
                              await prefs.saveTodoList(todos);
                              setState(() {});
                            },
                            onDelete: () {
                              AppDialog.dialog(
                                context,
                                title: const Text('😐'),
                                content: 'Delete this todo?',
                                action: () async {
                                  todos.removeWhere((e) => e.id == todo.id);
                                  searchList
                                      .removeWhere((e) => e.id == todo.id);
                                  await prefs.saveTodoList(todos);
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
            TodoModel todo = TodoModel()
              ..id = '${DateTime.now().millisecondsSinceEpoch}'
              ..text = text
              ..isDone = false;
            todos.add(todo);
            searchList = [...todos];
            // _search('');
            await prefs.saveTodoList(todos);
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
