import 'package:flutter/material.dart';
import 'package:flossygifs/ui/home_page.dart';
void main() async {
  runApp(MaterialApp(
    home: HomePage(),
    theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)))),
  ));
}
