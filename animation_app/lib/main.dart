import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'screens/home.dart';

void main() {
  //debugPaintSizeEnabled = false;
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }

}