import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import 'tessellation.dart';
import 'tessellationfigure.dart';
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
  ValueNotifier<Matrix4> zoom =
      new ValueNotifier<Matrix4>(new Matrix4.identity());
  bool _editing = true;

  @override
  void initState() {
    super.initState();
    figure = widget.figure;
    _resizeFigure();
  }

  Future<File> _getLocalFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String filename = "${appDir.path}/${widget.figure.uuid}.json";
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
    double scale =
        0.7 * math.min(s.size.width / r.width, s.size.height / r.height);
    double tx = -r.left * scale + (s.size.width - r.width * scale) / 2;
    double ty = -42.0 + -r.top * scale + (s.size.height - r.height * scale) / 2;
    Matrix4 transform = new Matrix4.identity()
      ..translate(tx, ty)
      ..scale(scale);
    zoom.value = transform;
  }

  Future<Null> _colorSettings() async {
    List<Color> _newcolors = await Navigator.push(context,
        new MaterialPageRoute<List<Color>>(builder: (BuildContext context) {
      return new FigureSettings(colors: figure.colors);
    }));
    if (_newcolors != null) {
      setState(() {
        figure.colors = _newcolors;
        //figure.description = _description;
      });
    }
  }

  Future<Null> _shareFigure() async {
    if (figure.uuid.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure.uuid = _nu.toString();
    }
    Directory storageDir = await getTemporaryDirectory();
    String filename = "${storageDir.path}/images/${figure.uuid}.png";

    final ui.PictureRecorder recorder = new ui.PictureRecorder();
    final ui.Rect paintBounds = new ui.Rect.fromLTRB(0.0, 0.0, 1024.0, 1024.0);
    final ui.Canvas canvas = new ui.Canvas(recorder, paintBounds);
    widget.figure.tessellate(canvas, paintBounds, 80.0);
    final ui.Image image = recorder.endRecording().toImage(1024,1024);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    new File(filename).create(recursive: true).then((File f) {
      f.writeAsBytesSync(byteData.buffer.asUint8List());
      shareImage(filename);
    });
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
            onPressed: _shareFigure,
          ),
          /*
          new PopupMenuButton<String>(
              onSelected: (String value) {
                 _handleMenu(context, value);
              },
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    const PopupMenuItem<String>(
                        value: 'Export SVG', child: const Text('Export SVG')),
                    const PopupMenuItem<String>(
                        value: 'Share', child: const Text('Share')),
                  ]),
          */
        ]),
        body: new Stack(children: <Widget>[
          new TessellationTiled(key: new Key(""), figure: figure),
          _editing
              ? new TessellationWidget(
                  key: new Key("tessellationeditor"),
                  figure: figure,
                  onChanged: _handleFigureChanged,
                  zoom: zoom)
              : const Center(child: const CircularProgressIndicator()),
        ]));
  }
}
