import 'package:flutter/material.dart';

AppBar buildAppBar(String text) {
  return AppBar(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Color(0xFF6200EE)),
    title: Text(
      text,
      style: TextStyle(color: Color(0xFF6200EE)),
    ),
  );
}
