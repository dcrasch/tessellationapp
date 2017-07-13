import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_picker/flutter_color_picker.dart';

import 'tessellation.dart';
import 'tessellationfigure.dart';
import 'tessellationlist.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<Directory> _appDocumentsDirectory;

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    String figurefile = '$dir/figure.json';
    return new File(figurefile);
  }

  Future<Null> _saveFigure(TessellationFigure figure) async {
    final JsonEncoder encoder = new JsonEncoder();
    final String code = encoder.convert(figure.toJson());
    await (await _getLocalFile()).writeAsString(code);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Tessellation'), actions: <Widget>[
        new IconButton(
            icon: const Icon(Icons.fullscreen),
            onPressed: () {
              //
            })
      ]),
      body: new Center(
          child: new FutureBuilder<TessellationFigure>(
              return new LinesWidget(figure: figure);
                                                       )),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            //showDialog(context: context, child: new ColorWheelDialog());
            //setState(() {
            //  _appDocumentsDirectory = getApplicationDocumentsDirectory();
            //});
          },
          tooltip: '',
          child: const Text('+')),
    );
  }
}
