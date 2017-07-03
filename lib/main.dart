import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_picker/flutter_color_picker.dart';

import 'tessellation.dart';
import 'tessellationfigure.dart';

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
      home: new MyHomePage(title: 'Tessellation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Directory> _appDocumentsDirectory;
  Future<TessellationFigure> _getSquare(AssetBundle bundle) async {
    final String code = await bundle.loadString('lib/diamond.json') ?? "failed";
    final JsonDecoder decoder = new JsonDecoder();
    final Map<String, dynamic> result = decoder.convert(code);
    return new TessellationFigure.fromJson(result);
  }

  Future<TessellationFigure> _getTriangle(AssetBundle bundle) async {
    final String code =
        await bundle.loadString('lib/triangle.json') ?? "failed";
    final JsonDecoder decoder = new JsonDecoder();
    final Map<String, dynamic> result = decoder.convert(code);
    return new TessellationFigure.fromJson(result);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Tessellation')),
      body: new Center(
          child: new FutureBuilder<TessellationFigure>(
              future: _getSquare(DefaultAssetBundle.of(context)),
              builder: (BuildContext context,
                  AsyncSnapshot<TessellationFigure> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return new LinesWidget(figure: snapshot.data);
                } else {
                  return const Text('You have not yet pressed the button');
                }
              })),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            showDialog(context: context, child: new ColorWheelDialog());
            setState(() {
              _appDocumentsDirectory = getApplicationDocumentsDirectory();
            });
          },
          tooltip: '',
          child: const Text('+')),
    );
  }
}
