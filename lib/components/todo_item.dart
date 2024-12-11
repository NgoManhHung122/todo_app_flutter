import 'package:flutter/material.dart';
import 'package:todo_app_flutter/models/todo_model.dart';
import 'package:todo_app_flutter/resources/app_color.dart';

class TodoItem extends StatelessWidget {
  const TodoItem(
    this.todo, {
    super.key,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final Function()? onTap;
  final Function()? onEdit;
  final Function()? onDelete;
  final TodoModel todo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0)
            .copyWith(left: 16.0, right: 12.0),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow,
              offset: Offset(0.0, 3.0),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              todo.isDone == true
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              size: 16.8,
              color: AppColor.orange,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                todo.text ?? '-:-',
                style: TextStyle(
                  color: AppColor.brown,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  decoration: () {
                    if (todo.isDone == true) {
                      return TextDecoration.lineThrough;
                    }
                    return TextDecoration.none;
                  }(),
                ),
              ),
            ),
            GestureDetector(
              onTap: onEdit,
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  backgroundColor: AppColor.orange.withOpacity(0.8),
                  radius: 12.6,
                  child:
                      const Icon(Icons.edit, size: 14.0, color: AppColor.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  backgroundColor: AppColor.grey.withOpacity(0.8),
                  radius: 12.6,
                  child: const Icon(Icons.delete,
                      size: 14.0, color: AppColor.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
