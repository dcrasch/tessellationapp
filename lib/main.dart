import 'package:flutter/material.dart';
import 'tessellationlist.dart';

void main() {
  runApp(new TessellationApp());
}

class TessellationApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, // for screenshots
      title: 'Tessellation App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TessellationList(),
    );
  }
}
