import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:relax_money/views/Home.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Colors.indigo,
      accentColor: Colors.amber,

      // Define the default TextTheme. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: TextTheme(
        headline: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    ),
    home: Home(),
  ));
}