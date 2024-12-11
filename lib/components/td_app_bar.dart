import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:todo_app_flutter/resources/app_color.dart';

class TdAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TdAppBar({
    super.key,
    this.iconPressed,
    this.color = AppColor.bgColor,
    required this.title,
    required this.icon,
  });

  final Function()? iconPressed;
  final Color color;
  final String title;
  final Icon icon;

  @override
  Size get preferredSize => const Size.fromHeight(90.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(
          top: MediaQuery.of(context).padding.top + 8.0, bottom: 12.0),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.png'),
            radius: 24.0,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              title,
              style: const TextStyle(color: AppColor.red, fontSize: 20.0),
            ),
          ),
          GestureDetector(
            onTap: iconPressed,
            child: Transform.rotate(
              angle: 45 * math.pi / 180,
              child: Container(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 4.6, right: 4.6, bottom: 8.0),
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadow,
                      offset: Offset(3.0, 3.0),
                      blurRadius: 4.0,
                    ),
                  ],
                ),
                child: Transform.rotate(
                  angle: -45 * math.pi / 180,
                  child: icon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
