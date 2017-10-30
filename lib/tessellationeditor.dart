import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:image/image.dart' as Im;

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
  ValueNotifier<Matrix4> zoom =
      new ValueNotifier<Matrix4>(new Matrix4.identity());

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

  Future<Null> _savePNG() async {
    if (figure.uuid.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure.uuid = _nu.toString();
    }
    Im.Image image = new Im.Image(1024, 1024);
    await this.figure.tessellateimage(image, 150.0);
    List<int> png = Im.encodePng(image);

    await (await _getLocalImageFile()).writeAsBytes(png);
  }

  Future<Null> _shareFigure() async {
    if (figure.uuid.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure.uuid = _nu.toString();
    }
    Im.Image image = new Im.Image(1024, 1024);
    await this.figure.tessellateimage(image, 150.0);
    List<int> png = Im.encodePng(image);
    Directory storageDir;
    if (Platform.isIOS) {
      storageDir = await getApplicationDocumentsDirectory();
    }
    else {
      storageDir = await getExternalStorageDirectory();
    }
    String filename = "${storageDir.path}/Tessellations/${figure.uuid}.png";
    new File(filename).create(recursive:true).then((File f) {
      f.writeAsBytes(png);
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
          new TessellationWidget(
              key: new Key("tessellationeditor"),
              figure: figure,
              onChanged: _handleFigureChanged,
              zoom: zoom),
        ]));
  }
}
