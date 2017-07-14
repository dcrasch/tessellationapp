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
import 'tessellationsettings.dart';

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
    String filename = "${appDir.path}/${widget.figure.uuid}.json";
    return new File(filename);
  }

  Future<Null> _saveFigure() async {
    if (widget.figure.uuid.isEmpty) {
      DateTime _nu = new DateTime.now();
      widget.figure.uuid = _nu.toString();
    }
    final JsonEncoder encoder = new JsonEncoder();
    String code = encoder.convert(widget.figure.toJson());
    await (await _getLocalFile()).writeAsString(code);
  }

  Future<Null> _resizeFigure() async {}

  Future<Null> _colorSettings() async {
    List<Color> _newcolors = await Navigator.push(context,
        new MaterialPageRoute<List<Color>>(builder: (BuildContext context) {
      return new FigureSettings(colors: widget.figure.colors);
    }));
    print(_newcolors);
    widget.figure.colors = _newcolors;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Tessellation'), actions: <Widget>[
        new IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveFigure,
        ),
        new IconButton(
          icon: const Icon(Icons.palette),
          onPressed: _colorSettings,
        ),
        new IconButton(
          icon: const Icon(Icons.fullscreen),
          onPressed: _resizeFigure,
        ),
      ]),
      body: new Center(child: new LinesWidget(figure: widget.figure)),
    );
  }
}
