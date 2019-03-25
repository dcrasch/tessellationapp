import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'tessellationeditor.dart';
import 'tessellationcreate.dart';
import 'tessellationfigure.dart';
import 'tessellation.dart';

class TessellationList extends StatefulWidget {
  const TessellationList({Key key}) : super(key: key);

  static const String routeName = '/material/list';

  @override
  _TessellationListState createState() => new _TessellationListState();
}

class _TessellationListState extends State<TessellationList> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<TessellationFigure> items = <TessellationFigure>[];

  @override
  void initState() {
    super.initState();
    _getItems().then((List<TessellationFigure> l) {
      setState(() {
        items = l;
      });
    });
  }

  void showFigure(BuildContext context, int i) async {
    TessellationFigure f = items[i];
    TessellationFigure result = await Navigator.push(context,
        new MaterialPageRoute<TessellationFigure>(
            builder: (BuildContext context) {
      return new TesellationEditor(figure: f);
    }));
    if (result != null) {
      setState(() {
        items[i] = result;
      });
    }
  }

  Future<File> _getLocalFile(figure) async {
    // TODO move file stuff to repo
    Directory appDir = await getApplicationDocumentsDirectory();
    String filename = "${appDir.path}/${figure.uuid}.json";
    return new File(filename);
  }

  void deleteFigure(BuildContext context, int i) async {
    // TODO move file stuff to repo
    final file = await _getLocalFile(items[i]);
    await file.delete();
    // remove from filesystem
    setState(() {
        items.removeAt(i);
      });
  }


  Future<List<TessellationFigure>> _getItems() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    List<TessellationFigure> myitems = <TessellationFigure>[];
    for (FileSystemEntity entity in appDir.listSync(recursive: false)) {
      // TODO skip failed
      if (entity is File && entity.path.endsWith('.json')) {
        String code = entity.readAsStringSync();
        final JsonDecoder decoder = new JsonDecoder();
        final Map<String, dynamic> result = decoder.convert(code);
        try {
          TessellationFigure f = new TessellationFigure.fromJson(result);
          myitems.add(f);
        } catch (e) {
          //print(e);
        }
      }
    }
    return myitems;
  }

  Widget _buildIcon(BuildContext context, TessellationFigure f) {
    Rect r = f.fit();
    double scale = 0.7 * math.min(48.0 / r.width, 48.0 / r.height);
    double tx = -24 + -r.left * scale + (48.0 - r.width * scale) / 2;
    double ty = -24 + -r.top * scale + (48.0 - r.height * scale) / 2;
    Matrix4 transform = new Matrix4.identity()
      ..translate(tx, ty)
      ..scale(scale);
    return new Container(
        padding: new EdgeInsets.all(12.0),
        child: new CustomPaint(
            painter: new TessellationPainter(f, transform, Colors.black)));
  }

  Widget _buildListTile(BuildContext context, int i) {
    TessellationFigure f = items[i];
    if (f != null) {
      return new Slidable(
        delegate: SlidableScrollDelegate(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => deleteFigure(context, i)
          ),
        ],
        child: ListTile(
          leading: _buildIcon(context, f),
          title: new Text('${f.description}'),
          //subtitle: new Text( DateFormat('yyyy-MM-dd kk:mm').format(f.created)),
          onTap: () {
            showFigure(context, i);
        }),
      );
    } else {
      return null;
    }
  }

  Future<Null> _onPressed() async {
    TessellationFigure f = await showDialog<TessellationFigure>(
        context: context, builder: _buildDialog);
    if (f != null) {
      setState(() {
        items.add(f);
      });
      showFigure(context, items.length - 1);
    }
  }

  Widget _buildDialog(BuildContext context) {
    return new TessellationCreate();
  }

  Widget _buildFigureList() {
    return new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          return _buildListTile(context, i);
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Figure List'),
        ),
        body: _buildFigureList(),
        floatingActionButton: new FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: _onPressed,
        ));
  }
}
