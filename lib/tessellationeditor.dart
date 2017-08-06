import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_color_picker/flutter_color_picker.dart';

import 'tessellation.dart';
import 'tessellationfigure.dart';
import 'tessellationlist.dart';
import 'tessellationsettings.dart';
import 'tessellationtiled.dart';

class FigurePage extends StatefulWidget {
  FigurePage({Key key, this.title, this.figure}) : super(key: key);

  final String title;
  TessellationFigure figure;

  @override
  _FigurePageState createState() => new _FigurePageState();
}

class _FigurePageState extends State<FigurePage> {
  TessellationFigure figure;
  ValueNotifier<Matrix4> zoom = new ValueNotifier<Matrix4>(new Matrix4.identity());

  @override
  void initState() {
    super.initState();
    figure = widget.figure;
    _resizeFigure();
  }

  Future<File> _getLocalFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String filename = "${appDir.path}/${widget.figure.uuid}.json";
    print(filename);
    return new File(filename);
  }

  Future<File> _getLocalImageFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String filename = "${appDir.path}/${widget.figure.uuid}.png";
    print(filename);
    return new File(filename);
  }

  Future<Null> _saveFigure() async {
    if (widget.figure.uuid.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure.uuid = _nu.toString();
    }
    final JsonEncoder encoder = new JsonEncoder();
    String code = encoder.convert(figure.toJson());
    await (await _getLocalFile()).writeAsString(code);
  }

  Future<Null> _resizeFigure() async {
    Rect r = figure.fit();
    MediaQueryData s = new MediaQueryData.fromWindow(ui.window);
    Matrix4 transform = new Matrix4.identity()
    ..translate(s.size.width*0.15, s.size.height*0.15)
    ..scale(0.7*math.min( s.size.width / r.width, s.size.height / r.height));
    zoom.value=transform;
  }

  Future<Null> _colorSettings() async {
    List<Color> _newcolors = await Navigator.push(context,
        new MaterialPageRoute<List<Color>>(builder: (BuildContext context) {
      return new FigureSettings(colors: figure.colors);
    }));
    if (_newcolors != null) {
      setState(() {
        figure.colors = _newcolors;
      });
    }
  }

  Future<Null> _savePNG() async {
    if (figure.uuid.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure.uuid = _nu.toString();
    }
    final ui.PictureRecorder recorder = new ui.PictureRecorder();
    final ui.Rect paintBounds = new ui.Rect.fromLTRB(0.0, 0.0, 100.0, 100.0);
    final ui.Canvas canvas = new ui.Canvas(recorder, paintBounds);
    figure.tessellate(canvas, paintBounds);
    final ui.Picture picture = recorder.endRecording();
    final ui.Image image = picture.toImage(1000, 1000);
    List<int> bytes = ui.encodeImageAsPNG(image);
    await (await _getLocalImageFile()).writeAsBytes(bytes);
  }

  void _handleFigureChanged(TessellationFigure figure) {
    setState(() {
      this.figure = figure;
    });
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
          new IconButton(
            icon: const Icon(Icons.import_export),
            onPressed: _savePNG,
          ),
        ]),
        body: new Stack(children: <Widget>[
          new Center(
              child: new TessellationTiled(key: new Key(""), figure: figure)),
          new Center(
              child: new TessellationWidget(
                  key: new Key("tessellationeditor"),
                  figure: figure,
                  onChanged: _handleFigureChanged,
                  zoom: zoom)),
        ]));
  }
}
