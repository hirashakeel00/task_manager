import 'package:flutter/material.dart';

Widget memberCard(final String name,VoidCallback onTap,final String avatar) {
  return Container(
    // padding: EdgeInsets.symmetric(vertical: 0.2),
    decoration: BoxDecoration(color: Color(0xFF455A64)),

    child: Row(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 7),
        CircleAvatar(radius: 12,backgroundImage: AssetImage(avatar),),

        SizedBox(width: 15),
        Text(name, style: TextStyle(color: Colors.white)),

        SizedBox(width: 13),

        // Icon(Icons.close, color: Colors.white, size: 18),
        IconButton(
          alignment: Alignment.centerRight,
          // color: Colors.white,
          onPressed: onTap,
          icon: Image.asset('assets/icons/closesquare.png'),
        ),
      ],
    ),
  );
}
