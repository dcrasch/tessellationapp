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

class FigurePage extends StatefulWidget {
  FigurePage({Key key, this.title, this.figure}) : super(key: key);
  final String title;
  TessellationFigure figure;
  @override
  _FigurePageState createState() => new _FigurePageState();
}

class _FigurePageState extends State<FigurePage> {
  Future<File> _getLocalFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    DateTime _nu = new DateTime.now();
    String guid = _nu.toString();
    String filename = "${appDir.path}/${guid}.json";
    return new File(filename);
  }

  Future<Null> _saveFigure() async {
    final JsonEncoder encoder = new JsonEncoder();
    String code = encoder.convert(widget.figure.toJson());
    await (await _getLocalFile()).writeAsString(code);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Tessellation'), actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveFigure,
        )
      ]),
      body: new Center(child: new LinesWidget(figure: widget.figure)),
    );
  }
}
