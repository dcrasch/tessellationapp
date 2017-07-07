import 'package:flutter/material.dart';
import 'tessellationlist.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Tessellation App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: new MyHomePage(title: 'Tessellation'),
      home:  new ListDemo(),
    );
  }
}