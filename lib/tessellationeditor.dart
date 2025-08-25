import 'dart:math' as math;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:undo/undo.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_selector/file_selector.dart';

import 'tessellation.dart';
import 'tessellationfigure.dart';
import 'tessellationsettings.dart';
import 'tessellationtiled.dart';
import 'tessellationline.dart';
import 'tessellationsvg.dart';

class TesellationEditor extends StatefulWidget {
  TesellationEditor({Key? key, this.title, this.figure}) : super(key: key);

  final String? title;
  final TessellationFigure? figure;

  @override
  _TesellationEditorState createState() => new _TesellationEditorState();
}

class _TesellationEditorState extends State<TesellationEditor> {
  TessellationFigure? figure;
  ValueNotifier<Matrix4> zoom =
      new ValueNotifier<Matrix4>(new Matrix4.identity());
  bool _editing = true;
  ChangeStack _changes = ChangeStack();

  @override
  void initState() {
    super.initState();
    figure = widget.figure;
    _resizeFigure();
  }

  Future<File> _getLocalFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String filename = "${appDir.path}/${figure!.uuid}.json";
    return new File(filename);
  }

  Future<bool> _onWillPop() async {
    if (kIsWeb) {
      await _storeFigure();
    } else {
      await _saveFigure();
    }
    Navigator.pop(context, figure);
    return new Future.value(false);
  }

  Future<Null> _saveFigure() async {
    if (figure!.uuid!.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure!.uuid = _nu.toString();
    }
    final JsonEncoder encoder = new JsonEncoder();
    String code = encoder.convert(figure!.toJson());
    await (await _getLocalFile()).writeAsString(code);
  }

  Future<Null> _storeFigure() async {
    // TODO repo
    if (figure!.uuid!.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure!.uuid = _nu.toString();
    }
    String figureId = figure!.uuid!;
    String? figures = localStorage.getItem('figures');
    List<dynamic> listresult = [];
    if (figures != null) {
      final JsonDecoder decoder = new JsonDecoder();
      listresult = decoder.convert(figures);
    }
    if (!listresult.contains(figureId)) {
      listresult.add(figureId);
    }
    String figureList = jsonEncode(listresult);
    localStorage.setItem('figures', figureList);

    final JsonEncoder encoder = new JsonEncoder();
    String code = encoder.convert(figure!.toJson());
    localStorage.setItem(figureId, code);
  }

  Future<Null> _resizeFigure() async {
    Rect r = figure!.fit();

    // TODO: add changes
    MediaQueryData s = new MediaQueryData.fromView(ui.window);
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
    Map? results = await Navigator.push(context,
        new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new FigureSettings(
          colors: figure!.colors, description: figure!.description);
    }));
    if (results != null) {
      // TODO: add changes
      setState(() {
        figure!.colors = results['colors'];
        figure!.description = results['description'];
      });
    }
  }

  /// Function to convert SVG to Data URL
  Future<Null> svgToDataUrl(String data) async {
    if (figure!.uuid!.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure!.uuid = _nu.toString();
    }
    String filename = "${figure!.uuid}.svg";

    if (!kIsWeb && Platform.isLinux) {

      const XTypeGroup typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['svg'],
      );
      final location = await getSaveLocation(
          suggestedName: filename, acceptedTypeGroups: <XTypeGroup>[typeGroup]);
      if (location != null) {
        new File(location.path).create(recursive: true).then((File f) {
          f.writeAsBytesSync(utf8.encode(data));
        });
      }
      return;
    }
    SharePlus.instance.share(ShareParams(
        text: figure!.description,
        files: [XFile.fromData(utf8.encode(data), mimeType: 'image/svg+xml')],
        fileNameOverrides: [filename]));
  }

  Future<Null> _shareFigure() async {
    if (figure!.uuid!.isEmpty) {
      DateTime _nu = new DateTime.now();
      figure!.uuid = _nu.toString();
    }
    String filename = "${figure!.uuid}.png";
    final ui.PictureRecorder recorder = new ui.PictureRecorder();
    final ui.Rect paintBounds = new ui.Rect.fromLTRB(0.0, 0.0, 1024.0, 1024.0);
    final ui.Canvas canvas = new ui.Canvas(recorder, paintBounds);
    figure!.tessellate(canvas, paintBounds, 80.0);
    final ui.Image image = await recorder.endRecording().toImage(1024, 1024);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (!kIsWeb && Platform.isLinux) {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'images',
        extensions: <String>['png'],
      );
      final location = await getSaveLocation(
          suggestedName: filename, acceptedTypeGroups: <XTypeGroup>[typeGroup]);
      if (location != null) {
        new File(location.path).create(recursive: true).then((File f) {
          f.writeAsBytesSync(byteData!.buffer.asUint8List());
        });
      }
      return;
    }
    SharePlus.instance.share(ShareParams(text: figure!.description, files: [
      XFile.fromData(byteData!.buffer.asUint8List(), mimeType: 'image/png')
    ], fileNameOverrides: [
      filename
    ]));
  }

  Future<Null> _exportSVG() async {
    await svgToDataUrl(TessellationSVG.convert(figure!));
  }

  void _handleFigureChanged(TessellationFigure? figure) {
    setState(() {
      this.figure = figure; // trigger change
    });
  }

  void _handleFigureAddPoint((Offset, PointIndexPath) p) {
    var (touchPoint, selectedPoint) = p;

    this._changes.add(Change(
          null, // oldvalue,
          () => this.figure!.addPoint(touchPoint, selectedPoint),
          (oldValue) => this.figure!.removePoint(selectedPoint),
          description: 'add point',
        ));
  }

  void _handleFigureModified((Offset, PointIndexPath) p) {
    var (touchPoint, selectedPoint) = p;
    this._changes.add(Change(
          this.figure!.getPoint(selectedPoint),
          () => this.figure!.updatePoint(selectedPoint, touchPoint),
          (oldValue) => this.figure!.updatePoint(selectedPoint, oldValue),
          description: 'move point',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            appBar:
                new AppBar(title: const Text('Tessellation'), actions: <Widget>[
              !kIsWeb
                  ? new IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: _saveFigure,
                    )
                  : new IconButton(
                      icon: const Icon(Icons.save), onPressed: _storeFigure),
              new IconButton(
                icon: const Icon(Icons.palette),
                onPressed: _colorSettings,
              ),
              new IconButton(
                icon: const Icon(Icons.fullscreen),
                onPressed: _resizeFigure,
              ),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: !_changes.canUndo
                    ? null
                    : () {
                        if (mounted)
                          setState(() {
                            _changes.undo();
                          });
                      },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: !_changes.canRedo
                    ? null
                    : () {
                        if (mounted)
                          setState(() {
                            _changes.redo();
                          });
                      },
              ),
              /*
                  new IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: _shareFigure,
                    )        ,
		    */
              new PopupMenuButton<String>(
                  onSelected: (String value) {
                    if (value == "Share") {
                      _shareFigure();
                    } else if (value == "Download SVG") {
                      _exportSVG();
                    }
                    //_handleMenu(context, value);
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuItem<String>>[
                        const PopupMenuItem<String>(
                            value: 'Download SVG',
                            child: const Text('Download SVG')),
                        const PopupMenuItem<String>(
                            value: 'Share', child: const Text('Share')),
                      ]),
            ]),
            body: new Stack(children: <Widget>[
              new TessellationTiled(key: new Key(""), figure: figure),
              _editing
                  ? new TessellationWidget(
                      key: new Key("tessellationeditor"),
                      figure: figure,
                      onChanged: _handleFigureChanged,
                      onModified: _handleFigureModified,
                      onAddPoint: _handleFigureAddPoint,
                      zoom: zoom)
                  : const Center(child: const CircularProgressIndicator()),
            ])));
  }
}
