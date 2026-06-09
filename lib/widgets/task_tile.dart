import 'package:flutter/material.dart';

// class TaskTile extends StatelessWidget {
//   final String title;
//   final bool completed;

//   const TaskTile({super.key, required this.title, required this.completed});

//   @override
//   Widget build(BuildContext context) {
//     const cardColor = Color(0xFF4A6270);
//     const yellowColor = Color(0xFFF2C95D);
Widget taskTile(final String title, bool isChecked, VoidCallback onTap) {
  const cardColor = Color(0xFF4A6270);
  const yellowColor = Color(0xFFF2C95D);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    height: 72,
    decoration: BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: yellowColor,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Checkbox(
            // visualDensity: VisualDensity.compact,
            value: isChecked,
            onChanged: (_) {
              onTap();
            },
            fillColor: WidgetStateProperty.all(yellowColor),
            checkColor: Colors.black,
            // side: BorderSide(color: Colors.black, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            side: WidgetStateBorderSide.resolveWith(
              (states) => BorderSide(color: Colors.black, width: 2),
            ),
          ),
        ),
      ],
    ),
  );
}
