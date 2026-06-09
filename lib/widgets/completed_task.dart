import 'package:flutter/material.dart';
import 'package:task_manager/widgets/avatar_list.dart';
import 'package:task_manager/screens/create_task.dart';

Widget completedTask(TaskModel task) {
  return Container(
    padding: EdgeInsets.all(8),
    // height: 90,
    width: 185,
    decoration: BoxDecoration(color: Color(0xFFFED36A)),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          task.title ?? '',
          style: TextStyle(
            fontFamily: 'PilatExtended',
            fontSize: 21,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Team members',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
            ),
            // SizedBox(height: 10),
            AvatarList(members: task.member ?? []),
          ],
        ),
        SizedBox(height: 10),

        Row(
          spacing: 55,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Completed'),
            Text('100%', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Image.asset('assets/images/Rectangle 12.png'),
      ],
    ),
  );
}
